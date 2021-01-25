class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://algo2.iti.kit.edu/schulz/software_releases/KaHIP_2.12.tar.gz"
  sha256 "b91abdbf9420e2691ed73cea999630e38dfaf0e03157c7a690a998564c652aac"
  revision 1

  bottle do
    cellar :any
    sha256 "5e9b5722965b55d3cfe41c64138da7d508f3677948783d10fa8bdc6cb14fd899" => :big_sur
    sha256 "2a3a941d05e8ac41cec5522f11fd835159ffb370452cf788adbcfe0d8c68d654" => :arm64_big_sur
    sha256 "a05c9bfbd38225e3730e10756f1515d833f09f61eccd7745c55dd8b78690b790" => :catalina
    sha256 "57e35f0a81e0d22f9d8d4438994efcc30295e54865525ba89236f58647f66174" => :mojave
    sha256 "78fda0b177b22dc65d0d9b5116dc842aa023cb027afccd4c2f968f42ac55fada" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    gcc_major_ver = Formula["gcc"].any_installed_version.major
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{gcc_major_ver}"
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
