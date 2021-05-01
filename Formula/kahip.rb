class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://algo2.iti.kit.edu/schulz/software_releases/KaHIP_2.12.tar.gz"
  sha256 "b91abdbf9420e2691ed73cea999630e38dfaf0e03157c7a690a998564c652aac"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "251a9daa84641cace789ee3a35512f139de3ff076690aba9a4b1f1518ec46307"
    sha256 cellar: :any, big_sur:       "2b70b966c1677ebd261ee0de5a25a1db63ebc2d565fc8cda7935ba5f09dc2dcf"
    sha256 cellar: :any, catalina:      "17060cfbab50579d52bfc82e71543ffc3832c1ffca61d03fe12e72ea238fcc3b"
    sha256 cellar: :any, mojave:        "43c9497861fdd75caf95132fbcb8af3e58aff877ac6e9cbd5ca2f307e96396ae"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  def install
    on_macos do
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
