class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.7.tar.gz"
  sha256 "c0de41a8c051e5d32b101b5f7014b98ca978b18e592f30ce6840b6d4602d947b"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bc762661550523d320eb4800a722f834d3a7f79d8d146ffa931af3b4f03a044"
    sha256 cellar: :any,                 arm64_sonoma:  "36e70e780a187bbd1737c7ac9ff58fbf93fcb7a428c57e5b8bdf574dbe5f3b72"
    sha256 cellar: :any,                 arm64_ventura: "c98de581a7c39b30775ee5e0903cfc608933ca15957cbfeded3feab0fd126259"
    sha256 cellar: :any,                 sonoma:        "c4dea04dba1efea22ee8380d3631a7fdf97eb3652caf54bc8d9cc0d502544322"
    sha256 cellar: :any,                 ventura:       "a0871c43ac8530c8a51c3b95c62ecad9ca3f4cbb526bfc5c37d58bffca29bdad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0b2df0414311fdbcb18fbaded353b58bdaaed679965a895871ba7d4b629864a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "348ae587ae09f3a9f4ba8e98043d80589b229cf9eb4a510726508c82c3ec595a"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.chrony.eu iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
