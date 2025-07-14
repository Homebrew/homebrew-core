class Perbase < Formula
  desc "Fast and correct perbase BAM/CRAM analysis"
  homepage "https://github.com/sstadick/perbase"
  url "https://github.com/sstadick/perbase/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "15fb5ac4ef4c7eae39292d0eb5fbfb5e5f8cd8fb0e88dab8983f856720a7e72d"
  license "MIT"
  head "https://github.com/sstadick/perbase.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "231fdd1559c4c3f10b8870998a9c4b65c368fdfecae4eb3ba3d6ffe57a266205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5604b687b1aa7cd0cd5c84f68a05e24d7942febb49208d65d759be4665bb241"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed8bfd3835387b2fa6819b7695d669ddfa47c06d8dd041e6843d8c9200d6a78a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f979210823cab603d0d1f567d42c3cfcb99e50d278033f4766e4071b3ad9ca8f"
    sha256 cellar: :any_skip_relocation, ventura:       "e24267375ab83ec58bd51ecd55115de408c73ecfbb8eeaa19be98d5c1abaa5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c002f3710e5ed513ed29f10ef31427f89ac4d790c4fd57e97135d70cf31a1d3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bamtools" => :test

  on_linux do
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/test.bam", testpath
    system Formula["bamtools"].opt_bin/"bamtools", "index", "-in", "test.bam"
    system bin/"perbase", "base-depth", "test.bam", "-o", "output.tsv"
    assert_path_exists "output.tsv"
  end
end
