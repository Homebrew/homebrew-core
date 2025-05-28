class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-17_00_0005.tar.gz"
  sha256 "290a5bd5f01baf1a011da5ede15e829fc880bc2540d39b7bbf95face86722688"
  license "LGPL-2.0-or-later"
  head "https://github.com/postgresql-interfaces/psqlodbc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^REL[._-]?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7301df560fe98f539315f6236b45b308afc94748ff8aa2b5b0e0cdb2d0900354"
    sha256 cellar: :any,                 arm64_sonoma:  "990accc6923fb034bc1ebbf5b7a5d820b9a85807c9a3e90c581f986a26215f46"
    sha256 cellar: :any,                 arm64_ventura: "ee44e2546f6ccb55b794d60d9883bdc6ae7095c171362da451988a7dde5ba545"
    sha256 cellar: :any,                 sonoma:        "96858de4ba34c85cbd12cf2c4ba028d93df8daaba4dd0a48785caad483eb4096"
    sha256 cellar: :any,                 ventura:       "73c5c8dc78b9cf9afc173a7dca7279a8012bbb6a5f5e59a9c0e5587c1a6ae3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140eaf0458d4fa234aa8505488ff9af1f2ba2301cd9c338003fd2abfbfc1fbcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d563442d2470bbe7519e5a3e72b62bcfa2028b8e6b84536e192b33cc54de220a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpq"
  depends_on "unixodbc"

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
