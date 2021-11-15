class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.12.tar.gz"
  sha256 "df923b94b552772d58b4c1f359b3f2e4a05f7f26ab4ebd00a0ab7d2579f4c257"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "35aaeb5b6017d06d68cfe54aef25d1a745ef4fdf5f0b41bb5e544e17cc5c49ec"
    sha256 cellar: :any,                 monterey:      "5bd59728b30733335ccb33cdadface3d183dc2e4e351104a19840495b8952ce6"
    sha256 cellar: :any,                 big_sur:       "b9be588260c93ea0c0d20a9f96d9b646341955e8842119f6325bcb6c29d4727f"
    sha256 cellar: :any,                 catalina:      "e71a62e66cf71370faa5108de3e8d1b21babf32974f0fe800e33885cddccaa93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76cc24151d1df1ac6eed61bb4f723f2013f3f9c506b790883972b043f1e8412c"
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
