class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.23.1.tar.gz"
  sha256 "8cf1b9a4eab29fca2f779ea186ae18f7ce444ce189c621925fa1a0c61dd5ff55"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "4c420da294aeb60d99852c98643f9b788c2ca6e454c3b2e1068f8f1b4665bf27" => :sierra
    sha256 "2398fa8024789551a2cb43df17727c0696a4e612d7f83d77fd92fbdbc3fc655a" => :el_capitan
    sha256 "d6b5468a9c05c698b1472884454aed52c4b4ae40400742f34f6bd08196770ee5" => :yosemite
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm"
  depends_on "pcre"
  depends_on "gmp"
  depends_on "libyaml" if build.with? "shards"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.23.0/crystal-0.23.0-1-darwin-x86_64.tar.gz"
    version "0.23.0"
    sha256 "5ffa252d2264ab55504a6325b7c42d0eb16065152d0adfee6be723fd02333fdf"
  end

  resource "shards" do
    url "https://github.com/crystal-lang/shards/archive/v0.7.1.tar.gz"
    sha256 "31de819c66518479682ec781a39ef42c157a1a8e6e865544194534e2567cb110"
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

    if build.with? "release"
      system "make", "crystal", "release=true"
    else
      system "make", "deps"
      (buildpath/".build").mkpath
      system "bin/crystal", "build", "-o", "-D", "without_openssl", "-D", "without_zlib", ".build/crystal", "src/compiler/crystal.cr"
    end

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
