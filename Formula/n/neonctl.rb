class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.com/docs/cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-9.9.3.tgz"
  sha256 "9c25f80048ba5fc73e108117e3d11ed6ef8af6eeacbbf47263ca2ee8528cba93"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "dc41c207e5dcaff97aa0af80d2b1e613ad5e4d7d9da4bdf0d4c08da592643b94"
    sha256 cellar: :any,                 arm64_golden_gate: "34edf77da2e01f2c26ba137c2941a38b266bb37831c110063b076aa3e661984b"
    sha256 cellar: :any,                 arm64_tahoe:       "34edf77da2e01f2c26ba137c2941a38b266bb37831c110063b076aa3e661984b"
    sha256 cellar: :any,                 arm64_sequoia:     "34edf77da2e01f2c26ba137c2941a38b266bb37831c110063b076aa3e661984b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d0bddbac8ffd389c199c3c85538d118730f43de1bfa8ce47dd21ee850867da64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e1b6ab26b7d5ab90a157d5f9b500d61a1f2253d13881769ffeb6ef7170c966ef"
  end

  depends_on "esbuild" # replaces the bundled copy
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end

    node_modules = libexec/"lib/node_modules/neonctl/node_modules"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Remove bundled esbuild to use the `esbuild` formula from PATH; delete the
    # whole module so neonctl falls back to PATH. Symlinks first to avoid dangling.
    node_modules.glob("**/.bin/esbuild").each { |bin| rm(bin) }
    node_modules.glob("**/{esbuild,@esbuild}").select(&:directory?).each { |dir| rm_r(dir) }
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)

    # `neonctl dev` bundles the function with esbuild and serves it, exercising
    # the `esbuild` dependency. Keep the source in its own dir: `dev` watches the
    # source's directory and restarts on any change, so the log must live outside it.
    (testpath/"neon").mkpath
    (testpath/"neon/index.ts").write <<~TS
      export default async () => new Response("Hello, Homebrew!");
    TS
    port = free_port
    log = testpath/"dev.log"
    # Poll instead of using FSEvents, which the `brew test` sandbox denies
    ENV["CHOKIDAR_USEPOLLING"] = "1"
    pid = spawn bin/"neonctl", "dev", "--source", testpath/"neon/index.ts", "--port", port.to_s,
                "--config-dir", testpath/"config", "--analytics", "false",
                out: log.to_s, err: log.to_s
    begin
      Timeout.timeout(60) do
        loop do
          contents = log.read if log.exist?
          break if contents&.include?("localhost:#{port}")

          refute_match "bundle failed", contents.to_s
          sleep 0.5
        end
      end
      assert_match "Hello, Homebrew!",
                   shell_output("curl --silent --retry 5 --retry-connrefused --retry-all-errors " \
                                "127.0.0.1:#{port}/")
    ensure
      begin
        Process.kill("TERM", pid)
        Process.wait(pid)
      rescue Errno::ESRCH, Errno::ECHILD
        nil
      end
    end
  end
end
