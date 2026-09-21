class Iqtree3 < Formula
  desc "Phylogenetics by maximum likelihood"
  homepage "http://www.iqtree.org"
  url "https://github.com/iqtree/iqtree3/archive/refs/tags/v3.1.4.tar.gz"
  sha256 "8bcba50d25263fb7e5d52d308f7d2a35545dd53f96e04cf44e6a0515be0f823b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc257799778fde421211fcbd0df317c84ec53587696550f03e6daeb339792aaf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e33ff1f5963b4ac45ef6a4b40ae9541ee891b4011c1ef524dc4f38595b1345d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6ce71f60f683e1fc6b5366ee0ad54dd287010dd864c2168b350497bc629266f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e2c8a928f24a2755451debca56c2a307f35dfd284ef362433f1b4b86448ed47d"
    sha256 cellar: :any,                 arm64_linux:       "18127abe13bc2b2f8fe7f2ff39729c9a10d4aa108cabb521c6b8a9453d83a3b5"
    sha256 cellar: :any,                 x86_64_linux:      "fc415ad7ea4b92ef5d8b7cfadbdc021fa4c7d77f5710d81d42e6123ef7b19963"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "lsd2" do
    url "https://github.com/tothuhien/lsd2/archive/c61110f3a4fa05325b45c97b2134792ff9d55d4c.tar.gz"
    version "c61110f3a4fa05325b45c97b2134792ff9d55d4c"
    sha256 "9bbeaa0f8f35783c1d8dec74df6c93a804dbca808fa04484f9123de4e7258b53"

    livecheck do
      url "https://api.github.com/repos/iqtree/iqtree3/contents/lsd2?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
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
