class Iqtree3 < Formula
  desc "Phylogenetics by maximum likelihood"
  homepage "http://www.iqtree.org"
  url "https://github.com/iqtree/iqtree3/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "df85370a2ac74289787226501401ac7db7f085f51c2110d4b829b3f210822160"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb5bab78cec04ce9c1ef1937fc7f3b7270e2884a705adc76c2b82b824aee4ac5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97a3ccb3cf2246ede9938bee894ac5d6eb23961e1a90dcbf0630135a4ec05063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003bc18dc66b43701ac5f41f12095094ce1ed2e145c26ff443cd868675ff069f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1c5810ba0468d089f62f4b96b4f01a0ba9d9b3a2fb8f62f5855aaf712973169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ddfc94e068ec16c99a267d70e371e61ee8e89a58d0e3e02d07fbe154ccfdbad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b3e39d526332c45b3e11b1540e39d45fba9af976f98faa3b8c156e020e69e4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build

  uses_from_macos "zlib"

  resource "lsd2" do
    url "https://github.com/tothuhien/lsd2.git",
        revision: "c61110f3a4fa05325b45c97b2134792ff9d55d4c"
  end

  def install
    resource("lsd2").stage buildpath/"lsd2"

    args = %W[
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
      -DIQTREE_FLAGS=single
      -DUSE_CMAPLE=OFF
      -DUSE_TERRAPHAST=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iqtree3 --version")

    cp_r pkgshare/"example/example.phy", testpath
    system bin/"iqtree3", "-s", "example.phy"
    assert_path_exists "example.phy.iqtree"
  end
end
