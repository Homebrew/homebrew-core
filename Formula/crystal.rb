class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.27.0.tar.gz"
    sha256 "43c8ac1b5c59ccea3cd58c9bd2a7af07a56f96cf1eff1e54d93f648b5340e83a"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    sha256 "fd57919e22be24ecf51e0da2d13c3a54ae8bc166bdcd1264deaacfc964b1c3bd" => :mojave
    sha256 "3c0396e3353fdefc933ec377941fb8c36ce12e2d4e458c1123c95ca1210a0731" => :high_sierra
    sha256 "27250e0754f7b3d592ab5499e65078c87c1c19d5257023bde50c0ab6b446f318" => :sierra
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@6"
  depends_on "pcre"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.26.1/crystal-0.26.1-1-darwin-x86_64.tar.gz"
    version "0.26.1-1"
    sha256 "3ad9616204d36ee4171e15892ee32216eab06f87f1f6cf5e32b45196dd4231d7"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_BUILD_COMMIT"] = Utils.popen_read("git rev-parse --short HEAD").strip
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:lib"
    ENV.append_path "PATH", "boot/bin"

    system "make", "deps"
    (buildpath/".build").mkpath

    system "bin/crystal", "build",
                          "-D", "without_openssl",
                          "-D", "without_zlib",
                          "-o", ".build/crystal",
                          "src/compiler/crystal.cr",
                          "--release", "--no-debug"

    resource("shards").stage do
      system buildpath/"bin/crystal", "build", "-o", buildpath/".build/shards", "src/shards.cr"
    end

    bin.install ".build/shards"
    bin.install ".build/crystal"
    prefix.install "src"
    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
