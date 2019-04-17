class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/schulzchristian/KaHIP/archive/v2.11.tar.gz"
  sha256 "9351902b9e1c53b16ac7c3ba499a8f52348cae945c5cfc00e82c2c68302e1dca"

  bottle do
    cellar :any
    sha256 "01a93ef9c4510c1925cc56e44fa9d1d1de61842bc5e3d7501b1a888ef22192f1" => :mojave
    sha256 "5f99e0c464f02c2f08afe55ee2fbd12f6b127ea769ccf8346a48ba57666b21ee" => :high_sierra
    sha256 "40ca42f0483f14493b18535cd0f9cc389f883ae468c1e7a2e6da643201413f22" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].version_suffix}"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version_suffix}"
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end
