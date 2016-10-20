class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.19.4.tar.gz"
  sha256 "e239afa449744e0381823531f6af66407ba1f4b78767bd67a9bb09d9fcc6b9e4"
  head "https://github.com/crystal-lang/crystal.git"
  revision 1

  bottle do
    sha256 "b570dcde6496464362a19e2fb15379b7d1c1ad0f93bfd8bac9d587393912d887" => :sierra
    sha256 "b86cac1fe2230791ed3de32db48d0e7729b08ed647699e240c0ceef496fe0510" => :el_capitan
    sha256 "8077a0a4a922112ec2438dbb99fc01931c14222a1c33a66218ad28d91036cab7" => :yosemite
  end

  # changes from upstream to fix compilation with LLVM 3.9
  patch do
    url "https://github.com/crystal-lang/crystal/pull/3439.diff"
    sha256 "ee55985315881461f1fd2fb7ccc36b547d5defb23a91b022c760d84abe328fd9"
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
