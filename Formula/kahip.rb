class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://algo2.iti.kit.edu/schulz/software_releases/KaHIP_2.12.tar.gz"
  sha256 "b91abdbf9420e2691ed73cea999630e38dfaf0e03157c7a690a998564c652aac"

  bottle do
    cellar :any
    sha256 "3c59b856d2b908f55fe555621a1ad866a1e4e2cbc1e07d13bda116d33d9f1ddc" => :mojave
    sha256 "5872593fdd32749fc4d11bff597808732428137b869840f5db65e7ef408e393c" => :high_sierra
    sha256 "cb925202435f91a405717bd7f5f162d54bdab0bccbdb87eaa817324d331211b0" => :sierra
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
