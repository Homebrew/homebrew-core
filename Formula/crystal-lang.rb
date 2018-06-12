class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.25.0.tar.gz"
    sha256 "78cc53289bd983598133f8b789d95e01fad0bc95b512d7ccf60e33e36710ddde"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.0.tar.gz"
      sha256 "7758bf3bf49cbb221456fc8a0fc1f78e4c9ef5e8b226615b03569b7e684f660b"
    end
  end

  bottle do
    sha256 "dee28ba7dd3e928736b6cac675e18baad1e6124cd70153aed3438399e85566cf" => :high_sierra
    sha256 "202fd9729a13992f855507ec85cf18850b286f694161872f846b18ee2a1eaef9" => :sierra
    sha256 "4d972d8e22dd8d1679ea910e50d3efc5e19350f0554837c25f8daed857da78dd" => :el_capitan
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm@5"
  depends_on "pcre"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libyaml" if build.with? "shards"

  resource "boot" do
    if MacOS.version <= :el_capitan # no clock_gettime
      url "https://github.com/crystal-lang/crystal/releases/download/v0.24.1/crystal-0.24.1-2-darwin-x86_64.tar.gz"
      version "0.24.1"
      sha256 "2be256462f4388cd3bb14b1378ef94d668ab9d870944454e828b4145155428a0"
    else
      url "https://github.com/crystal-lang/crystal/releases/download/0.24.2/crystal-0.24.2-1-darwin-x86_64.tar.gz"
      version "0.24.2"
      sha256 "05028a6ac8507b27a6dd5153f218deb255778d63ab7b45588cef3d974b5ce8ef"
    end
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = Utils.popen_read("git rev-parse --short HEAD").strip
    else
      ENV["CRYSTAL_CONFIG_VERSION"] = version
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:lib"
    ENV.append_path "PATH", "boot/bin"

    system "make", "deps"
    (buildpath/".build").mkpath

    command = ["bin/crystal", "build", "-D", "without_openssl", "-D", "without_zlib", "-o", ".build/crystal", "src/compiler/crystal.cr"]
    command.concat ["--release", "--no-debug"] if build.with? "release"

    system *command

    if build.with? "shards"
      resource("shards").stage do
        system buildpath/"bin/crystal", "build", "-o", buildpath/".build/shards", "src/shards.cr"
      end
      bin.install ".build/shards"
    end

    bin.install ".build/crystal"
    prefix.install "src"
    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
