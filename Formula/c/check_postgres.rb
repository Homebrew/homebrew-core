class CheckPostgres < Formula
  desc "Monitor Postgres databases"
  homepage "https://bucardo.org/wiki/Check_postgres"
  url "https://bucardo.org/downloads/check_postgres-2.26.0.tar.gz"
  sha256 "a3b135c1a205179410ee7b694e528704ebc12358781c98d3763d835872366995"
  license "BSD-2-Clause"
  head "https://github.com/bucardo/check_postgres.git", branch: "master"

  livecheck do
    url "https://bucardo.org/check_postgres/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "20317c9b4534bb9bb63f3318637c8d3b65162a78c7201f9f24d3e5f62efe178e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "357245d50daeb670b0e7acdf6ba808e045a3246a6a1666cded448100b78ffda5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8138d47d70f097677e5f9ae0d88e797e66395026b1d0615781492cb28294b96d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af79787c77281d36ab2852d98a020ed94c4360e494ad58ac8fff38852c0f9cab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af79787c77281d36ab2852d98a020ed94c4360e494ad58ac8fff38852c0f9cab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b229c41507d787d0783e608304dedc416e9a5b7b343fd2cce91a12c9aa92d4b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "599f04f4bd0fe98038e513c562f2ca8a0cb5fbaee326b2a78ac3e1c38fcaa7e3"
    sha256 cellar: :any_skip_relocation, ventura:        "f4023f4278d08648ad51b4c531a72e961e648736578efb14e6d44296af328496"
    sha256 cellar: :any_skip_relocation, monterey:       "f4023f4278d08648ad51b4c531a72e961e648736578efb14e6d44296af328496"
    sha256 cellar: :any_skip_relocation, big_sur:        "b37868aa190bf21cf2272f588d4e815b0621c873d824e1a13ab15bea6ceb2d4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8f1875eadbc232cfbc4e6a861d84981b2535167f18cdce21c64c5bdb6cda6550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15350f09487ed7fd501105b3abd217be8287cfdb4075b71673e179b1ba24cacc"
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

    rm_r(prefix/"lib")
  end

  test do
    # This test verifies that check_postgres fails correctly, assuming
    # that no server is running at that port.
    output = shell_output("#{bin}/check_postgres --action=connection --port=65432", 2)
    assert_match "POSTGRES_CONNECTION CRITICAL", output
  end
end
