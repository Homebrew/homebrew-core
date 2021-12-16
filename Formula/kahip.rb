class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.14.tar.gz"
  sha256 "9da04f3b0ea53b50eae670d6014ff54c0df2cb40f6679b2f6a96840c1217f242"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff4e9bd0b76d7fd28461265bdd37f2a649bb15045c1ee724a89ad43b6d8081be"
    sha256 cellar: :any,                 arm64_big_sur:  "a676f98f7478c94f26858f908d41925cc2ca41973feabf047c96cf970759777e"
    sha256 cellar: :any,                 monterey:       "7d02776c8a7eee5747c9f9b93c1bc2cbcdae286912dda6a59df0fa8a7cca59ab"
    sha256 cellar: :any,                 big_sur:        "b300ca67e943f079bf93526f746808a5621b585e0a65fff0562a85c1c445e52a"
    sha256 cellar: :any,                 catalina:       "81043fe57a6778018ceb47fbfc1b46a72244d63bca4ac312226e6b97dbf55f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "770cadf4665dfd5b6ce54a6d542509a0e4b5b05b0cfb40757711ae3998ce6615"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  def install
    if OS.mac?
      gcc_major_ver = Formula["gcc"].any_installed_version.major
      ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}"
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{gcc_major_ver}"
    end

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
