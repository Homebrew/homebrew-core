class Netcat < Formula
  desc "Utility for managing network connections"
  homepage "https://netcat.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/netcat/netcat/0.7.1/netcat-0.7.1.tar.bz2"
  sha256 "b55af0bbdf5acc02d1eb6ab18da2acd77a400bafd074489003f3df09676332bb"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c63948ab48476670f1d13d254c3d9ee3ce57fa9d06a5dbe47454ae9ec36f5977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9da6c99582155faec7fab7c54a568ea80695bb01fd04adc1ed646da91dd93367"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23d0bb45f7366fba2dc26498bfcc5e9711158738bb1c3592e8233dd70cdd8812"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b8d6a5ba62a3ea60b855cf4cff46ab35aeee9bb49966c3a769522a0df186a31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b67683e14760ec8ceda14c44b85d16411f5f3331e6385269fc6c1a4ee063273"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70fa1400d39bcb39a3452bca1c921d1cc76783d8fa2ad41b1742a0c317c1aceb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a180dd7c55283e66ee1baf8dbbfd1f9d45d77b4cf6c39e102ed210e03a88b63"
    sha256 cellar: :any_skip_relocation, ventura:        "de0cce7840c9836ae8003805ca0817d03e8c54e62ff4044fee1085a97883d033"
    sha256 cellar: :any_skip_relocation, monterey:       "7c33ed98a6c81011f5923240e11b87f07add5cea280f5e2754b2f3d7fc3d9eee"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec93ed2ce809a78373e1b747f20075fabe5e9d612e2f84f85f125e4ce81eadb3"
    sha256 cellar: :any_skip_relocation, catalina:       "13bd349dfb08b3a5a474498eec4e20ffff722f82446b255d9c6e0540b02b362b"
    sha256                               arm64_linux:    "eb080e6267d9f70f673e5069f58180210cabe7241fd1d3789415d72be31d9ada"
    sha256                               x86_64_linux:   "713b509412561ffe59ef45f828278384180ffc219547d9495409908ba421e259"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Fix running on Linux ARM64, using patch from Arch Linux ARM.
  # https://sourceforge.net/p/netcat/bugs/51/
  patch do
    on_arm do
      url "https://raw.githubusercontent.com/archlinuxarm/PKGBUILDs/05ebc1439262e7622ba4ab0c15c2a3bad1ac64c4/extra/gnu-netcat/gnu-netcat-flagcount.patch"
      sha256 "63ffd690c586b164ec2f80723f5bcc46d009ffd5e0dd78bbe56fd1b770fd0788"
    end
  end

  def install
    # Regenerate configure script for arm64/Apple Silicon support.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--mandir=#{man}", "--infodir=#{info}", *std_configure_args
    system "make", "install"
    man1.install_symlink "netcat.1" => "nc.1"
  end

  test do
    output = pipe_output("#{bin}/nc google.com 80", "GET / HTTP/1.0\r\n\r\n")
    assert_equal "HTTP/1.0 200 OK", output.lines.first.chomp
  end
end
