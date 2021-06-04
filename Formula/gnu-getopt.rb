class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.37/util-linux-2.37.tar.xz"
  sha256 "bd07b7e98839e0359842110525a3032fdb8eaf3a90bedde3dd1652d32d15cce5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "079587e59cd2e4061082a2582c4b57a61a76945c5520ef342408445ac454aed4"
    sha256 cellar: :any_skip_relocation, big_sur:       "e9b50df1befbbee936eda326aae7479e0a0557964eb29e5ae6ba68cd15f93a0e"
    sha256 cellar: :any_skip_relocation, catalina:      "f496f191c9e3d5dd178255bf2baac2e9933ff7aeef4904a10539e8b98e80df4c"
    sha256 cellar: :any_skip_relocation, mojave:        "804cd9ab8706b9aed9b2ebc7bccfbdbea97cc261bf0f0cb70ef9788070d8685a"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
