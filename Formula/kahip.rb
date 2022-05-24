class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.14.tar.gz"
  sha256 "9da04f3b0ea53b50eae670d6014ff54c0df2cb40f6679b2f6a96840c1217f242"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3ca758f3123e08b5ca8bdc6d871ac667e4e4c059bf8fa771b4d7b8faea5901e1"
    sha256 cellar: :any,                 arm64_big_sur:  "7f35c336c78e7d0a8094f97db34533e02755749557d4d91808b5aede4d01e1e5"
    sha256 cellar: :any,                 monterey:       "cffb766beda21575c6367a0390e6cdcdbe68091ba21352e42dcdf3796726010e"
    sha256 cellar: :any,                 big_sur:        "05929f1f281044afdb8663cb9a2a7cac66b07181ae2b66f1eb0cff32923ba300"
    sha256 cellar: :any,                 catalina:       "7d006b6467f459beac409f17ce38a1b800c06e96df08b50d29ed34dc5f822227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb760f3de464f04a3341f6ef5b9c00ad8a26702cdf3f0da20957546aace735e8"
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
