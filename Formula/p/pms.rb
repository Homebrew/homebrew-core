class Pms < Formula
  desc "Practical Music Search, an ncurses-based MPD client"
  homepage "https://kimtore.github.io/pms/"
  url "https://downloads.sourceforge.net/project/pms/pms/0.42/pms-0.42.tar.bz2"
  sha256 "96bf942b08cba10ee891a63eeccad307fd082ef3bd20be879f189e1959e775a6"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9ea144b1cf1481050e378149ef8731963f537878c38d74faa182a687e85d64a0"
    sha256 cellar: :any,                 arm64_sequoia:  "24de40d237ca53721190a990da548b37b777fa60e7599c9c0c0dcf289333bbeb"
    sha256 cellar: :any,                 arm64_sonoma:   "2992d520cbc631a4764f7387d6f37efbb9dc5d75a387993217fb83204fa17a50"
    sha256 cellar: :any,                 arm64_ventura:  "b5b477e377dcf2b781a503e8eb00673d7218e43d788fa56b70b960fad91c26f9"
    sha256 cellar: :any,                 arm64_monterey: "5928678a604a80ee70d57b581b408890b4137d3c16f6123e3e455b636c36c14d"
    sha256 cellar: :any,                 arm64_big_sur:  "c119951216c45f24ff265bb5046631b6cbd5730300b8f4d441e7ac2be1363fcd"
    sha256 cellar: :any,                 sonoma:         "a931529745300c09aa3f2b9a9b0099927a8d268904771ae80adc6e1cb31df1f3"
    sha256 cellar: :any,                 ventura:        "c1bad14da37f77e32560f8369ec9978d7bdf9f23027a9e6e3be067e37ab8eded"
    sha256 cellar: :any,                 monterey:       "1c75eaf6c2e4a91e9c48323faf5c1426e53856447ce511002187c90001f72cb1"
    sha256 cellar: :any,                 big_sur:        "61b7be3d89ec3436b9e14733936d31564c6989bccb05cb675e529383ba799924"
    sha256 cellar: :any,                 catalina:       "de929bc53474adfa2a300f8954e0597489f88c22a29661e85c66d1ea8cc619ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "49c08001404ac52846502ef4173d8df4907aa2f3ce45bd55c48faf3c672100da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3d1cf4ac839cd2c6ae549d4c303dfeed70951bf0473b4919bcbe62a2530961"
  end

  depends_on "pkgconf" => :build

  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/pms -?", 4)
    assert_match "Practical Music Search v#{version}", output
  end
end
