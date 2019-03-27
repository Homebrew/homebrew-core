class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/schulzchristian/KaHIP/archive/v2.11.tar.gz"
  sha256 "9351902b9e1c53b16ac7c3ba499a8f52348cae945c5cfc00e82c2c68302e1dca"

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
    system "#{bin}/interface_test"
  end
end
