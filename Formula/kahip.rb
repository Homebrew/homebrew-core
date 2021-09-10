class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.11.tar.gz"
  sha256 "347575d48c306b92ab6e47c13fa570e1af1e210255f470e6aa12c2509a8c13e3"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7dd775db6db3f292630fef80ed2372b302e6d2caaaa1aa36259f9c9cd316bc42"
    sha256 cellar: :any,                 big_sur:       "b020b5b9e72805576099c1a4cd13c5bf0ac07c7451f22150bb8b1213029ac83f"
    sha256 cellar: :any,                 catalina:      "9d37b651ac2a278ec406cdab07d9c61fbc4ee5fc18b299d9fc640d13ddd3e01e"
    sha256 cellar: :any,                 mojave:        "3426ae40721153a746e297e6fc0ceceb6f07fd6df88f2ebdcca830ccc16e9c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0258d4bb8fc771b98528c7f45c014985d65b1ffd23e7f3628a2c424985f37b94"
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
