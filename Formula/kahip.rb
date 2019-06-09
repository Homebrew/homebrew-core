class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/schulzchristian/KaHIP/archive/v2.11.tar.gz"
  sha256 "9351902b9e1c53b16ac7c3ba499a8f52348cae945c5cfc00e82c2c68302e1dca"
  revision 1

  bottle do
    cellar :any
    sha256 "adf04905ebd11dca87434d8185a16e910522bd2faaf983dc20c2f83819da9b4b" => :mojave
    sha256 "99eab0a417cd7596eebd646f3da9571a40ce0154e88dcfd01361ab2bb4721282" => :high_sierra
    sha256 "7061f28f5f464e69c5b4af293e1aa4a13f14b86ad56889f9d2d6be54c632f199" => :sierra
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
