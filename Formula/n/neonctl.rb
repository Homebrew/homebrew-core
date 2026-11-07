class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-8.23.2.tgz"
  sha256 "6bcae9d332fbf489334c5c3481936e2711b2fd1a0c4c6ebca327f0a1f2a3bb82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d9b1db0b69d5b7de9a3ec67c2f5a6e5864e5769b261ad48e3449255b8defdbd8"
    sha256 cellar: :any,                 arm64_tahoe:       "d9b1db0b69d5b7de9a3ec67c2f5a6e5864e5769b261ad48e3449255b8defdbd8"
    sha256 cellar: :any,                 arm64_sequoia:     "d9b1db0b69d5b7de9a3ec67c2f5a6e5864e5769b261ad48e3449255b8defdbd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "26307d52f8c6dcc766f36d4b4c9077f3efd03348e0e5ce02928ba684d3ef57f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4fd97fcfecdc1905b8c55276b51d9aa8ab1543b2bd1bd2329fbd4a91cb1dc5df"
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
