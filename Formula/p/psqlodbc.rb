class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-17_00_0007.tar.gz"
  sha256 "cf15619e7fcc31ce3f61634243ca9fbb1e1c7dfdac19d7bda2a66483c029d4b5"
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
    sha256 cellar: :any,                 arm64_tahoe:   "03b67640b469646a99bf276c37d0b69930ceaf598608757d83ccd8c14830ecfe"
    sha256 cellar: :any,                 arm64_sequoia: "3f0f9535604f96b43b15fccdf8dae4d087d4e6277794171eca929f5c287090ae"
    sha256 cellar: :any,                 arm64_sonoma:  "ea0b38460d4dc7bff71339d7e60278e4198c2ffe802e2e180b3d471924c49741"
    sha256 cellar: :any,                 sonoma:        "bf485ea2d9ed662eca21eee44e597ae4d775e584942122829bffe1712a7377e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c22729921780e27592be2ec849f20a14b865e99425127b583fc204587902985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb8ee6431090c3e9c8de6c55505b6a3fc623ed7065d1414392f472f02a3fc5c"
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
