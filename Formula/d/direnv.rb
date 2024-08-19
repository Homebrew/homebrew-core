class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "3d7067e71500e95d69eac86a271a6b6fc3f2f2817ba0e9a589524bf3e73e007c"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "fd210e16bd6764b33cd2e556a7f07ed579453ba19d518ec11de33edcf3c5c2c7"
    sha256 arm64_ventura:  "59af7e0d05a50eda59d60a8c2c67eb0a3491c0650a334568ae13988da3b32951"
    sha256 arm64_monterey: "2577f8c5e2c3c7d1ee2f6966e3c92a16853edb9302d78089ddfc4f8ef9efda24"
    sha256 sonoma:         "4148bce1352772af61eb44303877e57e54a8531240cb551ec2c879660ac90c54"
    sha256 ventura:        "b4eefec1b63c6c32713290af5f5e1f2c318d3c64ba052aab786aab0b87c1b437"
    sha256 monterey:       "41cadfe20ab1913f07376ac5206ee49c3322ac8689ecd9a5dc85c5146850dff2"
    sha256 x86_64_linux:   "be4b933f8f607bf1a705c13abe75d04a99856f1698c3ebcb71e07e469850e964"
  end

  depends_on "go" => :build
  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}", "BASH_PATH=#{Formula["bash"].opt_bin}/bash"
  end

  test do
    system bin/"direnv", "status"
  end
end
