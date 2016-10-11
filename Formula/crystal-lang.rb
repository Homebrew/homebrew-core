class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.19.4.tar.gz"
  sha256 "e239afa449744e0381823531f6af66407ba1f4b78767bd67a9bb09d9fcc6b9e4"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "b891e7a9c01906be5b6d51adc374c1882e036ae443b95abb1a8f27b072762fde" => :sierra
    sha256 "928c541573faaeb82030d2fcbee7f4b5865b54cd0cb4f080adab00035394d9f5" => :el_capitan
    sha256 "0faca697844e5ef7bbcf9d750ed27c448e224363c7150ebebc77c73f01099e07" => :yosemite
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm"
  depends_on "pcre"
  depends_on "gmp"
  depends_on "libyaml" if build.with? "shards"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.19.3/crystal-0.19.3-1-darwin-x86_64.tar.gz"
    version "0.19.3"
    sha256 "2c9aebfefe2aca46eeda1e5a3fd6a91e3177af8f324ea23ebf8b5cad3c87ad2d"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.6.4.tar.gz"
    sha256 "5972f1b40bb3253319f564dee513229f82b0dcb8eea1502ae7dc483a9c6da5a0"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = Utils.popen_read("git rev-parse --short HEAD").strip
    else
      ENV["CRYSTAL_CONFIG_VERSION"] = version
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:libs:lib"
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
    zsh_completion.install "etc/completion.zsh" => "crystal"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
