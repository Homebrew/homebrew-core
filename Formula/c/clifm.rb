class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.18.tar.gz"
  sha256 "b3293074a62542c0ba54bd246391f9e38e0d48ea80c222bf8112469cb97a550c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "83e226991beacf9107cf7777e1d62e4d7ac69e7418cfdb63b3787245140983a3"
    sha256 arm64_ventura:  "c5c026645db8c7f2499b3c6a0efdb0d6583b107ac663d69146d4a728c6671f9d"
    sha256 arm64_monterey: "d254a82d542c830e217cb98bfc5e6f77469eb6cfa37c08e503859385b49c86d9"
    sha256 sonoma:         "d08acf9bd05cab1964f7a5a59e9734335042a67f9e924eee1daecdfc4626e6df"
    sha256 ventura:        "e9029393212ffd88d0888c97502e9ddbb253428ee38fbca6528fbd9126494473"
    sha256 monterey:       "3ef008a51e47867dd7a3d516e0e41ac989332fd753fbd2f5d73a33cd4112a291"
    sha256 x86_64_linux:   "a9056eca0db230823c2dacdbc18480d9dd48a426d58252c3c2bbe4d5afca6a5c"
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
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end
