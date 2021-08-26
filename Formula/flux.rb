class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.126.0",
      revision: "5daaedac25dfa11cf577e9a662e59e5c721f80ed"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aea08a78bb80ee7516f21f6348d6f20ef2650ac2e9b01c6e2cc04e7dd26b7890"
    sha256 cellar: :any,                 big_sur:       "1da07124b6ad59d30bf8ccde096dff76a5ed3e7091a309a1df1f1bdee1bc4624"
    sha256 cellar: :any,                 catalina:      "40d35419e6bc79c2c7a9611422c3bc65fa3627a28701cba37b58e32f2ca7e945"
    sha256 cellar: :any,                 mojave:        "e28ade1e99d9fca4ac651d36cdde2bdbc8210dabb22d9016d8958998e3c13ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b457162d8370978373b61e0ab629f88a024728a88cb1c141384c141b83a29f"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/influxdata/flux/pull/3982
  patch do
    url "https://github.com/influxdata/flux/commit/233c875bcb7d071d47149b0730d1cb5f15eb6a5a.patch?full_index=1"
    sha256 "fadb3ee0dc5efec615b6ffc4338f9a0947d42b58406b393587754fab0196ca62"
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
