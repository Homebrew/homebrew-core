class Pnpm < Formula
  require "language/node"
  require "patchelf/helper"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v6.14.7.tar.gz"
  sha256 "6a4d691bd0fcc22d9991f5eb4536c1696f7c4930d0186e676c7ec4d85e2b9f23"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce026b672adfcbfa83bd4bc87d92ea153dc318baeb1ea1f1a0abe98e1bd2f747"
    sha256 cellar: :any_skip_relocation, big_sur:       "39888df742337216af95a19dc405d9f7f7417380f4ee23349d6720216c1fde56"
    sha256 cellar: :any_skip_relocation, catalina:      "39888df742337216af95a19dc405d9f7f7417380f4ee23349d6720216c1fde56"
    sha256 cellar: :any_skip_relocation, mojave:        "39888df742337216af95a19dc405d9f7f7417380f4ee23349d6720216c1fde56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce026b672adfcbfa83bd4bc87d92ea153dc318baeb1ea1f1a0abe98e1bd2f747"
  end

  depends_on "node@14" => :build

  # Described in https://github.com/pnpm/pnpm#installation
  # Managed by https://github.com/pnpm/get
  resource "pnpm-buildtime" do
    url "https://get.pnpm.io/v6.14.js"
    sha256 "c80817f1dac65ee497fc8ca0b533e497aacfbf951a917ff4652825710bbacda7"
  end

  patch do
    url "https://github.com/umireon/pnpm/commit/4013c14e1409934b98d586cde65845268530688a.patch?full_index=1"
    sha256 "50f76f48078cb935e3720f035e259002e1504152907972561d88d97bb4b29255"
  end

  patch do
    url "https://github.com/umireon/pnpm/commit/b7d21cd0720eac4a5acc6c02e4229a35b9fc9cb9.patch?full_index=1"
    sha256 "0b0771a6c85a00b4ca92ba62ed001786ada48d619ca3b34b6f9ed78dbfcc007b"
  end

  def install
    (prefix/"etc").mkpath
    (prefix/"etc/npmrc").atomic_write "pnpm-bin = ${HOME}/Library/pnpm\n" if OS.mac?
    (prefix/"etc/npmrc").atomic_write "pnpm-bin = ${HOME}/.local/pnpm\n" if OS.linux?

    buildtime_bin = buildpath/"buildtime-bin"
    resource("pnpm-buildtime").stage do |r|
      buildtime_bin.install "v#{r.version}.js"
      (buildtime_bin/"pnpm").write_env_script "#{Formula["node@14"].bin}/node",
        buildpath/"buildtime-bin/v#{r.version}.js", {}
      chmod 0755, buildtime_bin/"pnpm"
    end
    ENV.prepend_path "PATH", buildtime_bin
    system "pnpm", "install"
    chdir "packages/pnpm" do
      system "pnpm", "run", "compile"
    end
    chdir "packages/beta" do
      system "node_modules/.bin/pkg", "--target=host", "../pnpm/dist/pnpm.cjs"
      bin.install "pnpm"
    end
  end

  def post_install
    if OS.linux?
      lib.mkpath
      marker = lib/"SHIFTED"
      unless marker.exist?
        executable = bin/"pnpm"
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
        marker.atomic_write ""
      end
    end
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
