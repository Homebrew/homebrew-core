class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.13.7.tar.gz"
  sha256 "d5fb51849eead3d4d442b1b6d352e2114bcc1bddea5b4578a06a19285fc5f224"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3232006df4ad89baea6bc0bb38dee7aa56429205c2456d0632a616200234562e"
    sha256 cellar: :any,                 arm64_big_sur:  "d8abcaf46fe96f3e244ed2d07815ca354581c31f5266381d514473b696c543f1"
    sha256 cellar: :any,                 monterey:       "99123b5eb3fd2176a7f88f18e15e637fd8f59a67053159bcc7f78a591683866e"
    sha256 cellar: :any,                 big_sur:        "98a991a6f62abaefbb3d9f7e1558ae73cc90eccc774ea26aebadfa38868d4dd6"
    sha256 cellar: :any,                 catalina:       "53bc81164848633944d7bfae6499187fe6bc138c841212ba99230413e1b4449f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2710494a91d33770331c4940f18d3905ae23691037c8a2ee405114d80c4a7c3d"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
