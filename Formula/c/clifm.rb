class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.14.6.tar.gz"
  sha256 "f26b9ee1c41f02ec50dcae4108865b7f463d6dcf5dbd1f0271fbe1dbed93b2a1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "48a91f74710d9575f33e85673707a5270ae2e516d0f2fdd3c49cdd84ea14d8f8"
    sha256 arm64_ventura:  "e3bd211f34fd99670724ed5b334f54fd141097e120c8f2431e5008fb218d1baa"
    sha256 arm64_monterey: "2ab7f27b8d53efcf6c5a1449f3cf4d751fbb5d11557166b52968889b901682e9"
    sha256 arm64_big_sur:  "ba5fcb45b1c66b9ccaa0a2dd68c799154af693c32f1fa2b6d02849065a89183a"
    sha256 sonoma:         "3b364c581ff722c8af0788dbf6d06bee6264e259f87171697eebc2d7e422e4cb"
    sha256 ventura:        "9ed28887dd4d23ec26247224ceec5332b8166da887412d5e4892154a5f3b3362"
    sha256 monterey:       "a11b66a2b67c2306638c4db3cdb48087f5ec57e15d4e4be63047a8c55bb826e7"
    sha256 big_sur:        "fa0149d54de9a375ff250ea2a0d8aca27ff276d7fcd7dfc04edb4521bac25832"
    sha256 x86_64_linux:   "fa273ff811c036be867199414107b2410e1b2b4069e924e86946dd12fb538c5a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "libmagic"
  depends_on "readline"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: nonexist: No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end
