class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.10.tar.gz"
  sha256 "d58dc08f0205373d1a811b888c6db5192deeb3271f056daf2fc9ba89654832c5"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7838960157c7a4dcf2752d9c9ec052bd4ab9e720b9614166496836e27abef22d"
    sha256 cellar: :any, big_sur:       "3d4062b822961bca86be0cbb658896a73af607f6fa040084041143d283b0a271"
    sha256 cellar: :any, catalina:      "e4067631417a7a8a09aeb7599be89d6a1bf218bbfcbdebb8a4ed95f2f6f30eef"
    sha256 cellar: :any, mojave:        "3be779a531ce19ebb82b8adfcbb6a305eeb1f730df44d80cff59fc95f583ab93"
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
