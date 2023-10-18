class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.6.tar.gz"
  sha256 "0280888e5b8e4c4fb93bf40e65e4e8a1ba316a0456f308164fb5c2b2b0c282d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3294616f99757de70922c857f850edc056160628537e9073ff633116af74be4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b30900296a9302b9d9c671ef0378ff3f72cb3e10f7cf2e99863252a68020699"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49723a07d6d9bdc90d32fc281fd4a4d7b88a9486a4c3979653d93f576efd21a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "198550f68b65961b9732cc97c861268043a06d291cbc25fe75bf55b6eb9a4cea"
    sha256 cellar: :any_skip_relocation, sonoma:         "241712caea7e38232c05696bd5f2f82d555ec2565034543e459fd7e538f15296"
    sha256 cellar: :any_skip_relocation, ventura:        "6e77e04849d1ebcac81b34370e687be99d1dd06ac75fabf1a9daf5a3883826e6"
    sha256 cellar: :any_skip_relocation, monterey:       "6063f6f10d70cf58fbe658dffc3046443bc2528194ca696c12ea6e5e2eb93190"
    sha256 cellar: :any_skip_relocation, big_sur:        "adef68270316f1efc16fbef07cbb0ef7d7754744daac10a3fdd526736ab1a3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd62e843573d136148e7b71bfe17f9fb51a6ff60f66dd1e447c481d783141d96"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", * std_cmake_args
      system "make", "install"
    end
    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    system "#{bin}/draco_encoder", "-i", "#{pkgshare}/cube_att.ply",
           "-o", "cube_att.drc"
    assert_predicate testpath/"cube_att.drc", :exist?
  end
end
