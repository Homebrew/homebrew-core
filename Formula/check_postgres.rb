class CheckPostgres < Formula
  desc "Monitor Postgres databases"
  homepage "https://bucardo.org/wiki/Check_postgres"
  url "https://bucardo.org/downloads/check_postgres-2.25.0.tar.gz"
  sha256 "11b52f86c44d6cc26e9a4129e67c2589071dbe1b8ac1f8895761517491c6e44b"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/bucardo/check_postgres.git", branch: "master"

  livecheck do
    url "https://bucardo.org/check_postgres/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e960bf564777b225109a65302d5f7ca36a11831ae9bc7ba9765168e191c37e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e960bf564777b225109a65302d5f7ca36a11831ae9bc7ba9765168e191c37e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce72f3c88ea89aa7fd974e400d36e1ffe72531a2903476776680208d0e26a916"
    sha256 cellar: :any_skip_relocation, ventura:        "ceae380da1a94e242438fb48bfe0db455a22abdea4ee86132779bcb337b931b3"
    sha256 cellar: :any_skip_relocation, monterey:       "ceae380da1a94e242438fb48bfe0db455a22abdea4ee86132779bcb337b931b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "057605346ab18b273061dd719c70ff02ffb232416a19ad93ededf31170bafe3e"
    sha256 cellar: :any_skip_relocation, catalina:       "1e5d5939f4e5fe39416e7ca38959cf0898c437247df83c27c90ceb12612b6182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a1cbba8fe70c4f97e918ddbd8e5ab5c9fadc30e57080941d896a67dc79aa1ba"
  end

  depends_on "libpq"
  uses_from_macos "perl"

  def install
    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"

    mkdir_p libexec/"bin"
    mv bin/"check_postgres.pl", libexec/"bin/check_postgres.pl"
    inreplace [libexec/"bin/check_postgres.pl", man1/"check_postgres.1p"], "check_postgres.pl", "check_postgres"

    (bin/"check_postgres").write_env_script libexec/"bin/check_postgres.pl", PATH: "#{Formula["libpq"].opt_bin}:$PATH"

    rm_rf prefix/"Library"
    rm_rf prefix/"lib"
  end

  test do
    # This test verifies that check_postgres fails correctly, assuming
    # that no server is running at that port.
    output = shell_output("#{bin}/check_postgres --action=connection --port=65432", 2)
    assert_match "POSTGRES_CONNECTION CRITICAL", output
  end
end
