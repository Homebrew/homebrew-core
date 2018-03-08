class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  revision 1

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.24.2.tar.gz"
    sha256 "de50a455a509f4f80025eb8773818859ad6664a79f5f0fafecdd87ff5ccef6d0"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.7.2.tar.gz"
      sha256 "97a3681e74d2fdcba0575f6906f4ba0aefc709a2eb672c7289c63176ff4f3be2"
    end
  end

  bottle do
    sha256 "704f49cb6ecde5fbee10e6edd4cc2096bc8761a065789de2164c30582e7e74f5" => :high_sierra
    sha256 "eb38543677beabfb6d9231d42c70a97ff0d85a01b4e84abed7e514ba5a5cb59a" => :sierra
    sha256 "e352bdf530244df5d3c9abacc2bbb04853ee421c8c2d57969244849e72313fc0" => :el_capitan
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
    url "https://github.com/crystal-lang/crystal/releases/download/v0.24.1/crystal-0.24.1-2-darwin-x86_64.tar.gz"
    version "0.24.1"
    sha256 "2be256462f4388cd3bb14b1378ef94d668ab9d870944454e828b4145155428a0"
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
