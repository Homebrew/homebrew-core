class Iqtree3 < Formula
  desc "Phylogenetics by maximum likelihood"
  homepage "http://www.iqtree.org"
  url "https://github.com/iqtree/iqtree3/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "df85370a2ac74289787226501401ac7db7f085f51c2110d4b829b3f210822160"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae6440023e30272346d61eb64544cad03cdcd28ce5534881ea57e68741d9804a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7be3601ecc0577748794a0cedc0f2bcb559c6c58f30b4b2d9d71ddf708b390fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aa9e27195328385963ee3820070cd3fe336c96f53e2e3db1f89ae23de05ed05"
    sha256 cellar: :any_skip_relocation, sonoma:        "c87a0732f7b3d034580a7c12ca67a4adbe3e783ddf46468d229e7e800123abb4"
    sha256 cellar: :any,                 arm64_linux:   "5c93f778819bb6cbad85f83b54597776ee4f70ced9053cb6554f6faf78f08f1b"
    sha256 cellar: :any,                 x86_64_linux:  "aed8a1b92653deafe99be38cef420dd6fcb6388f5cc07a99cf1e637ee750ac2e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "lsd2" do
    url "https://github.com/tothuhien/lsd2.git",
        revision: "c61110f3a4fa05325b45c97b2134792ff9d55d4c"
  end

  def install
    resource("lsd2").stage buildpath/"lsd2"

    args = %W[
      -DEIGEN3_INCLUDE_DIR=#{formula_opt_include("eigen")}/eigen3
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
