class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.9.tar.gz"
  version "0.29.0.gfm.9"
  sha256 "07cd91514c29f8d68bcd1bd159661bf92ac060fdb08f6b2e33ce01d3b3000f54"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63e5943a8b66e842f66be138217795287152fddda3256b6fbca9beee5ecedc82"
    sha256 cellar: :any,                 arm64_monterey: "c475fb7d160bd94d3675c20080b901bc798ccf27ed8e020c4935d6ae1f856c18"
    sha256 cellar: :any,                 arm64_big_sur:  "320d2819740bc81e401286180c5e3011b71f7c3228bc6448757cf91cf887a136"
    sha256 cellar: :any,                 ventura:        "3d0a45a87c98a276be8c0b02e3759e8b2ee915849291b6295ea65ceac45d35a0"
    sha256 cellar: :any,                 monterey:       "85bd57704ed685041232044c495f83b1ed65bd303db1e1014dab5b50ebf6fe06"
    sha256 cellar: :any,                 big_sur:        "328213bf1714faa1a8c3e2a87d2ecf8d759bb9a137dd4e51a87ddbe1f3ad6b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cd0cc6dd5bd93a0b22e61e90eac1c559b03440e0acb9fd5b547aa14d509533f"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
