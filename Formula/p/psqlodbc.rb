class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-18_00_0000.tar.gz"
  sha256 "0ccc83385e085b3d09eca92e113058703c0b594e57b5fa2704e6e11d03ca7050"
  license "LGPL-2.0-or-later"
  head "https://github.com/postgresql-interfaces/psqlodbc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^REL[._-]?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae1c4c85041cbe5d2c678b51cd9487f95a39238ab10b95fe8087f5d808f28850"
    sha256 cellar: :any,                 arm64_sequoia: "61c715d3d1ab896b0be8809a04713e949ec9af6662e42bb2abffbc5923ccc460"
    sha256 cellar: :any,                 arm64_sonoma:  "310a95e49b95c324244002c1de0b5eb4a1467dcc76c9ad2bb1f146fd9c522bf5"
    sha256 cellar: :any,                 sonoma:        "500dcf91a30c43e5715ca70479cd01db5429ad771e50f3b85ba29ec7568eb972"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "983391d830f6284a7f22381766e383e3b93e958a3ab96b71e8f352c4fed4e314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d029c722836216752cd9ab0d72e8f929e368e5175b288edeba9f50bbfe98c06f"
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
