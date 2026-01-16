class Flactag < Formula
  desc "Tag single album FLAC files with MusicBrainz CUE sheets"
  homepage "https://flactag.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/flactag/v2.0.4/flactag-2.0.4.tar.gz"
  sha256 "c96718ac3ed3a0af494a1970ff64a606bfa54ac78854c5d1c7c19586177335b2"
  license "GPL-3.0-or-later"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a51e19be9701ccbe86b20cbe0444217655d0e0c0c02779a0784b4e5bc5830f4f"
    sha256 cellar: :any,                 arm64_sequoia: "8701c9513901987485c41ce6778104199cac3fabcdfcc1fc2c82717ededa93e8"
    sha256 cellar: :any,                 arm64_sonoma:  "e65ce7a13bb6a8e11483996b87de1e8240dcdddf394762c4b9b4c42e411e6649"
    sha256 cellar: :any,                 arm64_ventura: "14dbd80290e58fdb2bbef0ac5fe5479e01cd1072cf2ac4b183072050939e15a7"
    sha256 cellar: :any,                 sonoma:        "21d528f25b5c20a9be98ff0323b8bca94b41c0b33192b28b46956a09d65dd5c2"
    sha256 cellar: :any,                 ventura:       "9e3b475328f5b9eabd9417c5d40e64cd7d82c6b9157924c257016887a9ed6065"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9b3c2851aee52a5b3f5954b61ec129ed2053e002abb0d2826aae54fdf447d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd364c130a6702197e495c69f00c3ed7306ea96734700a3c8ce63d9d8c1a1bba"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libmusicbrainz"
  depends_on "neon"
  depends_on "s-lang"
  depends_on "unac"

  uses_from_macos "libxslt"

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/flactag/jpeg9.patch"
    sha256 "a8f3dda9e238da70987b042949541f89876009f1adbedac1d6de54435cc1e8d7"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    ENV.append "LDFLAGS", "-lFLAC"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"flactag"
  end
end
