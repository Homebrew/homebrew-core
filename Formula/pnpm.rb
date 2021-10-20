class Pnpm < Formula
  require "patchelf/helper"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v6.18.0.tar.gz"
  sha256 "cd0903eb4e5e01fb341b4d88462f3f1e1d233480aa81e6d32f3ebbc7206cc41a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90f4bfa844ecbf63c420e1afb045e7c989013e4ead33aa9fde86dc0c72dd1dab"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c7ae9d2b4050fdb126888fb16dc0fc03ae674350d368c9ffc692060c97b1a33"
    sha256 cellar: :any_skip_relocation, catalina:      "6c7ae9d2b4050fdb126888fb16dc0fc03ae674350d368c9ffc692060c97b1a33"
    sha256 cellar: :any_skip_relocation, mojave:        "6c7ae9d2b4050fdb126888fb16dc0fc03ae674350d368c9ffc692060c97b1a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f4bfa844ecbf63c420e1afb045e7c989013e4ead33aa9fde86dc0c72dd1dab"
  end

  depends_on "node" => :build

  # Described in https://github.com/pnpm/pnpm#installation
  # Managed by https://github.com/pnpm/get
  resource "pnpm-bootstrap" do
    url "https://get.pnpm.io/v6.14.js"
    sha256 "c80817f1dac65ee497fc8ca0b533e497aacfbf951a917ff4652825710bbacda7"
  end

  def install
    (prefix/"etc").mkpath
    (prefix/"etc/npmrc").atomic_write "global-bin-dir = ${HOME}/Library/pnpm\n" if OS.mac?
    (prefix/"etc/npmrc").atomic_write "global-bin-dir = ${HOME}/.local/pnpm\n" if OS.linux?

    bootstrap_bin = buildpath/"bootstrap"
    resource("pnpm-bootstrap").stage do |r|
      bootstrap_bin.install "v#{r.version}.js"
      (bootstrap_bin/"pnpm").write_env_script Formula["node"].bin/"node", buildpath/"bootstrap/v#{r.version}.js", {}
      chmod 0755, bootstrap_bin/"pnpm"
    end
    ENV.prepend_path "PATH", bootstrap_bin
    system "pnpm", "install"
    cd "packages/pnpm" do
      system "pnpm", "run", "compile"
    end
    cd "packages/exe" do
      system "node_modules/.bin/pkg", "--target=host", "../pnpm/dist/pnpm.cjs"
      bin.install "pnpm"
    end
  end

  def post_install
    return unless OS.linux?

    # Linuxbrew patches the ELF header when a binary is installed from bottle.
    # Patching would change the position of JavaScript code embedded in the binary.
    # Changing position results in the binary not being executable.
    # Recalculating the offset will resolve this issue.
    #
    # Refer to https://github.com/vercel/pkg/issues/321
    # Also to https://github.com/NixOS/nixpkgs/pull/48193/files
    executable = bin/"pnpm"
    unless (system_command executable).success?
      default_interpreter_size = 27 # /lib64/ld-linux-x86-64.so.2
      return if executable.interpreter.size <= default_interpreter_size

      offset = PatchELF::Helper::PAGE_SIZE
      binary = File.binread executable
      binary.sub!(/(?<=PAYLOAD_POSITION = ')((\d+) *)(?=')/) do
        (Regexp.last_match(2).to_i + offset).to_s.ljust(Regexp.last_match(1).size)
      end
      binary.sub!(/(?<=PRELUDE_POSITION = ')((\d+) *)(?=')/) do
        (Regexp.last_match(2).to_i + offset).to_s.ljust(Regexp.last_match(1).size)
      end
      executable.atomic_write binary
    end
  end

  def caveats
    pnpm_path = nil
    on_macos do
      pnpm_path = "$HOME/Library/pnpm"
    end
    on_linux do
      pnpm_path = "$HOME/.local/pnpm"
    end
    <<~EOS if pnpm_path
      Add the following to #{shell_profile} or your desired shell
      configuration file if you would like global packages in PATH:

        export PATH="#{pnpm_path}:$PATH"
    EOS
  end

  test do
    ENV.prepend_path "PATH", testpath/"Library/pnpm" if OS.mac?
    ENV.prepend_path "PATH", testpath/".local/pnpm" if OS.linux?
    system "#{bin}/pnpm", "env", "use", "--global", "16"
    system "#{bin}/pnpm", "install", "--global", "npm"
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
