class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  revision 2

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.24.1.tar.gz"
    sha256 "4999a4d2a9ffc7bfbea8351b97057c3a135c2091cbd518e5c22ea7f5392b67d8"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.7.2.tar.gz"
      sha256 "97a3681e74d2fdcba0575f6906f4ba0aefc709a2eb672c7289c63176ff4f3be2"
    end
  end

  bottle do
    sha256 "fd9e9c2cd01b52a27b85421bd00c2d11fb27bb24b16498d409b1abd666d17ef6" => :high_sierra
    sha256 "6b76c04f8f6f036b3f3bf4909f73590d6e13251fca1e6a0f3941abc2fbe07686" => :sierra
    sha256 "c01126afd64bcd1c59e9a6595f2aa4befdcd235a320f87a0dacc3db3813dbfe6" => :el_capitan
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
  depends_on "llvm"
  depends_on "pcre"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libyaml" if build.with? "shards"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.23.1/crystal-0.23.1-3-darwin-x86_64.tar.gz"
    version "0.23.1"
    sha256 "d3f964ebfc5cd48fad73ab2484ea2a00268812276293dd0f7e9c7d184c8aad8a"
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
