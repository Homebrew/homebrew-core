class Dfc < Formula
  desc "Display graphs and colors of file system space/usage"
  homepage "https://github.com/Rolinh/dfc"
  url "https://github.com/Rolinh/dfc/releases/download/v3.1.1/dfc-3.1.1.tar.gz"
  sha256 "962466e77407dd5be715a41ffc50a54fce758a78831546f03a6bb282e8692e54"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Rolinh/dfc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "6aa0c0d2ad81bf179b61fced051ea22e5cb85376eafbb8e1d7376d8f3fc9cec7"
    sha256 arm64_big_sur:  "6f2d7350e0c7e1c905718b6dcf282367bc846bbd51538a9a525f681dda03be61"
    sha256 monterey:       "127dd250819075427ca4a6f35f292d29c4af8b070c6ee368645817d54ac5a50b"
    sha256 big_sur:        "a89714cadb5ca91708c9f0c0f37266726517418e0ee592003c1cff38cc7599b1"
    sha256 catalina:       "cefa6f0f5e96a815ebbee4d4618dc927f88052f4137d52c31d21688fac211aa8"
    sha256 mojave:         "93406a46f6e08d861ddbc5ea7f4ce910629f33090c39eeb827f05444d61fe466"
    sha256 x86_64_linux:   "0d467920d7e3393975fc11b8fa07f84e177ddafdfa7139bc219183380f891d42"
  end

  depends_on "cmake" => :build
  depends_on "gettext"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"dfc", "-T"
    assert_match ",%USED,", shell_output("#{bin}/dfc -e csv")
  end
end
