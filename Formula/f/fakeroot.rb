class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.34.orig.tar.gz"
  sha256 "5727f16d8903792588efa7a9f8ef8ce71f8756e746b62e45162e7735662e56bb"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab5a8016d23d6bc2951a866d6f715d4165dc7d8d427899255171e4c1d22507a5"
    sha256 cellar: :any,                 arm64_ventura:  "c268d747ea6098566436caf552e2958e5df5481ea7752aca77b1939d73043f08"
    sha256 cellar: :any,                 arm64_monterey: "6e852eaec06661d8cd95120e999ebd4d30e5e4ade41cff4b429d747da4282e62"
    sha256 cellar: :any,                 sonoma:         "1b50b42fbe6c3a898c0b14712218bc269e17e305caa78d02f5b96c2986ca5dab"
    sha256 cellar: :any,                 ventura:        "a398d10ee3cd8042926f68076309b349245480ac3e883325fcc5eefa12b4e439"
    sha256 cellar: :any,                 monterey:       "732632cffbc827de2bd6956b2f1545d2b3ce363fbc155851680cfb66a7c52445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28801a57eebcdd39f664ebfb36ae3369980e9a2769fd3bb48659f69936dfbc9"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/17
  patch :p0 do
    # The MR has a typo, so we use MacPorts' version.
    url "https://raw.githubusercontent.com/macports/macports-ports/0ffd857cab7b021f9dbf2cbc876d8025b6aefeff/sysutils/fakeroot/files/patch-message.h.diff"
    sha256 "6540eef1c31ffb4ed636c1f4750ee668d2effdfe308d975d835aa518731c72dc"
  end

  def install
    system "./bootstrap" # remove when patches are no longer needed

    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
