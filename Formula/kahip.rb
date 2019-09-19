class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://algo2.iti.kit.edu/schulz/software_releases/KaHIP_2.12.tar.gz"
  sha256 "b91abdbf9420e2691ed73cea999630e38dfaf0e03157c7a690a998564c652aac"

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
