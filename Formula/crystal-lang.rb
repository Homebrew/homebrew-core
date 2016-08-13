class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  revision 1

  head "https://github.com/crystal-lang/crystal.git"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.18.7.tar.gz"
    sha256 "72b33fd4bd903a9f0957c74c2f95429e8c0f94c04df86396711b5560f540805d"

    # LLVM 3.8 support patches begin.
    patch do
      url "https://github.com/crystal-lang/crystal/commit/53f1977c8c.patch"
      sha256 "a89ba25a5e7469c225680a58e87d4342a2709477dce61215803d9422cf8d0860"
    end

    patch do
      url "https://github.com/crystal-lang/crystal/commit/19ddb4c3a.patch"
      sha256 "f98b92d9003d2fa69fe36e218329cc616198e4a6283ba81b7c27e84d9d4afac0"
    end

    patch do
      url "https://github.com/crystal-lang/crystal/commit/63ca4950e4.patch"
      sha256 "bb0cbb466673f7f04996326c875c8c7f9a0335e31a3bfab1576358fdf8a697f1"
    end
    # LLVM 3.8 support patches end.
  end

  bottle do
    sha256 "3227b27a079cc88de3b055e866782d9fdd156150320fb8838c5f65b8908fb4dc" => :el_capitan
    sha256 "892de4081627a7b9a6b672a2ad7ee39fff96e742abc9a59207cec88ed27c754d" => :yosemite
    sha256 "e0b7d0b104b7f8d519faeb38c64aaacab9fb61d5bc6eaeac0a6f685c53a60cf3" => :mavericks
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm"
  depends_on "pcre"
  depends_on "libyaml" if build.with? "shards"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.18.6/crystal-0.18.6-1-darwin-x86_64.tar.gz"
    version "0.18.6"
    sha256 "ce4e282edbf35542cee2cc95a1feb070612716200f142f712707c17cf4175c48"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.6.3.tar.gz"
    sha256 "5245aebb21af0a5682123732e4f4d476e7aa6910252fb3ffe4be60ee8df03ac2"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = Utils.popen_read("git rev-parse --short HEAD").strip
    else
      ENV["CRYSTAL_CONFIG_VERSION"] = version
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:libs"
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
