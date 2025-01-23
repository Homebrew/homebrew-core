class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.47.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.47.tar.gz"
  sha256 "e0111d863f9ef55715582f4b69a7ffd261645e0c89417cefeb308cd080002e04"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d53b73a265962f2dad328124bfd05367fd59efec760220aaa247535b5e7bc7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e668ded889a22e0953f8cab1ce0b03e9597bdc0ef2669a88efbbaf4733012ce5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "578f456364445caea870466f74698a93f9d9eee02ac02c352109aaa1fb47a599"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce38ebffec47298f665a4da7c03eb53d1924a8f11f4b33cda1bfc237b7166265"
    sha256 cellar: :any_skip_relocation, ventura:       "24f9f92c7d58025aae895995ce1f3357bff278bcaa90ff2d982cce119317ef37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9a13385804a53dc214cdb1f5d21c5a00f6e053020a2e8d69e80f5a0c0fe7f2"
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end
