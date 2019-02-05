class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.27.2.tar.gz"
    sha256 "d2fe8a025668b143e8ff70b3cd407765140ed10e52523dd08253139f9322171b"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    cellar :any
    sha256 "02ffbf3bbf8c8f6b87e1df7d639e6357f34af0b2d639b85f5584a1356e942288" => :mojave
    sha256 "5d85f9b5ca33b86583ea0d3ed9fb2b2f148f891d281772f96f4dd632e2aaca02" => :high_sierra
    sha256 "3ca6feba06c02cdc2432dcff7618ec34a528fc89637807734d8de883ed30794d" => :sierra
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@6"
  depends_on "pcre"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.27.1/crystal-0.27.1-1-darwin-x86_64.tar.gz"
    version "0.27.1-1"
    sha256 "f5102f34b6801a1bae3afe66fb6da15308cc304c3a9fba5799f4379c1e3010b1"
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
                          "-D", "preview_overflow",
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
