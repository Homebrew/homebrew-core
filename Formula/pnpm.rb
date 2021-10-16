class Pnpm < Formula
  require "patchelf/helper"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v6.15.1.tar.gz"
  sha256 "25c691cc2d7e3af7df2f12b152911e64d0db1f63356b7f84fad54c68ea2e0e67"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0d669c48801ee9a3f0a49d99f81f2a50dcd1e879526b77a1367c1ae6daa9811"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf54f4d92677826a6d9eaf8653cffb849708dde2ac0291336e3d37fbd0de847d"
    sha256 cellar: :any_skip_relocation, catalina:      "cf54f4d92677826a6d9eaf8653cffb849708dde2ac0291336e3d37fbd0de847d"
    sha256 cellar: :any_skip_relocation, mojave:        "cf54f4d92677826a6d9eaf8653cffb849708dde2ac0291336e3d37fbd0de847d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0d669c48801ee9a3f0a49d99f81f2a50dcd1e879526b77a1367c1ae6daa9811"
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

    bootstrap_bin = buildpath/"buildtime-bin"
    resource("pnpm-bootstrap").stage do |r|
      bootstrap_bin.install "v#{r.version}.js"
      (bootstrap_bin/"pnpm").write_env_script Formula["node"].bin/"node", buildpath/"buildtime-bin/v#{r.version}.js", {}
      chmod 0755, bootstrap_bin/"pnpm"
    end
    ENV.prepend_path "PATH", bootstrap_bin
    system "pnpm", "install"
    cd "packages/pnpm" do
      system "pnpm", "run", "compile"
    end
    chdir "packages/beta" do
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
      binary = IO.binread executable
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
