class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.20.0.tar.gz"
  sha256 "97118becc450cdfbafd881f8e98e93d9373d71b4994f49f41dec1eaf081e8894"
  head "https://github.com/crystal-lang/crystal.git"

  bottle do
    sha256 "21df0a01eef973a76692fb0b8ca1620127526788eaedc9fee6d1bcd8e960857a" => :sierra
    sha256 "87f0f8b6ef3b86a0523f1316813eb4f6fc9214216b154caf1f48857697ea06ef" => :el_capitan
    sha256 "269c98e96daeb8bdc9db13eaae7057bdee60a30a23aea9f4ed987808e85792ee" => :yosemite
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
    url "https://github.com/crystal-lang/crystal/releases/download/0.19.4/crystal-0.19.4-1-darwin-x86_64.tar.gz"
    version "0.19.4"
    sha256 "ec9f21f29035b76b2bc32bd3d975aa057f68007191cc6aab1535effe4c1c60d5"
  end

  resource "shards" do
    url "https://github.com/crystal-lang/shards/archive/v0.7.0.tar.gz"
    sha256 "2e8e20cb0dcaed7f756146954b8946bd01d98d9462740233b204647e5aa628a2"
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
