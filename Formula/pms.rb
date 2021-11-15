class Pms < Formula
  desc "Practical Music Search, an ncurses-based MPD client"
  homepage "https://pms.sourceforge.io"
  url "https://downloads.sourceforge.net/project/pms/pms/0.42/pms-0.42.tar.bz2"
  sha256 "96bf942b08cba10ee891a63eeccad307fd082ef3bd20be879f189e1959e775a6"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5928678a604a80ee70d57b581b408890b4137d3c16f6123e3e455b636c36c14d"
    sha256 cellar: :any,                 arm64_big_sur:  "c119951216c45f24ff265bb5046631b6cbd5730300b8f4d441e7ac2be1363fcd"
    sha256 cellar: :any,                 monterey:       "1c75eaf6c2e4a91e9c48323faf5c1426e53856447ce511002187c90001f72cb1"
    sha256 cellar: :any,                 big_sur:        "61b7be3d89ec3436b9e14733936d31564c6989bccb05cb675e529383ba799924"
    sha256 cellar: :any,                 catalina:       "de929bc53474adfa2a300f8954e0597489f88c22a29661e85c66d1ea8cc619ff"
    sha256 cellar: :any,                 mojave:         "0c43ee20313b6616c6ececb9c906da12720b035862a894a3f9dd11984c640b30"
    sha256 cellar: :any,                 high_sierra:    "f01d2f4db91f6b6bcf35f86c7a0d2b0fbed17941d9556fe0ba71e855c7667638"
    sha256 cellar: :any,                 sierra:         "fa90afc92fc9d1e57a9a0a74dc63d3ec5ba92f1430caf5cad8fa54362b0da298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3d1cf4ac839cd2c6ae549d4c303dfeed70951bf0473b4919bcbe62a2530961"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Practical Music Search v#{version}/,
                 shell_output("#{bin}/pms -?", 4))
  end
end
