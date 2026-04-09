class Minicom < Formula
  desc "Menu-driven communications program"
  homepage "https://packages.debian.org/sid/minicom"
  url "https://deb.debian.org/debian/pool/main/m/minicom/minicom_2.10.orig.tar.bz2"
  sha256 "90e7ce2856b3eaaa3f452354d17981c49d32c426a255b6f0d3063a227c101538"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/minicom/"
    regex(/href=.*?minicom[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "33a6f5dbbe7ca27534ae675480528a30c197ceee9bfe12a6662b88d20b923c11"
    sha256 arm64_sequoia: "80e14a35d53c8bee7865f9dca76d9b674b5790d18d3dd1b468847ed99970c96f"
    sha256 arm64_sonoma:  "00ee0220e0307094c74374572ffbca318368f33083b9881b22783d36d4a12ca6"
    sha256 arm64_ventura: "f004fb2db42fbdd149fc40eae5bc653b15860f06506f2d91f3be7b7e3b62f4e1"
    sha256 sonoma:        "ae861c3e3530b8dd98ddd8256aa243a3205a6dac85e04f9351f5fc157d3948bf"
    sha256 ventura:       "7e524e53bc69ffd181757cff6564264674e1bc2c46255792c58b3265f9fe61dc"
    sha256 arm64_linux:   "4b8d28ea107b2c8577fa25a16f3607f4b85bcc230d67657b2c4e90db42466159"
    sha256 x86_64_linux:  "5de5bb5448b6444e3ddcdcbb615bd96fb138df6d216c565e661e101ebd507208"
  end

  head do
    url "https://salsa.debian.org/minicom-team/minicom.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    # There is a silly bug in the Makefile where it forgets to link to iconv. Workaround below.
    ENV["LIBS"] = "-liconv" if OS.mac?

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"

    (prefix/"etc").mkdir
    (prefix/"var").mkdir
    (prefix/"etc/minirc.dfl").write "pu lock #{prefix}/var\npu escape-key Escape (Meta)\n"
  end

  def caveats
    <<~EOS
      Terminal Compatibility
      ======================
      If minicom doesn't see the LANG variable, it will try to fallback to
      make the layout more compatible, but uglier. Certain unsupported
      encodings will completely render the UI useless, so if the UI looks
      strange, try setting the following environment variable:

        LANG="en_US.UTF-8"

      Text Input Not Working
      ======================
      Most development boards require Serial port setup -> Hardware Flow
      Control to be set to "No" to input text.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minicom -v")
  end
end
