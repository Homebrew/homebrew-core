class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://github.com/postgresql-interfaces/psqlodbc/archive/refs/tags/REL-18_00_0001.tar.gz"
  sha256 "2cf6f19d72765f0b8c2a8a9f4000f1ae1835e737c4899dc931dd6d7a7a0c87dc"
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
    sha256 cellar: :any,                 arm64_tahoe:   "8ea1a4ecf8e6a609fdc9b2c38efc6a1f48c905420eee73abc502e466de797328"
    sha256 cellar: :any,                 arm64_sequoia: "904625a0bf31b2b254a7e6832a98a4e9cd9ac738895564a69ade039223b22b90"
    sha256 cellar: :any,                 arm64_sonoma:  "85e059770deb50b4132d96040507431fe243470b4273102432ba9b6a84a1f6ba"
    sha256 cellar: :any,                 sonoma:        "319330d341a6d3bab2fe8f0c197f9f647fb3255cb07e8f539199dcee639014c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0ddc9cac55df470dfe893d2bc17678471f17723acadbcebb82615539c3872f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ef65df1154b69caecb031b91196a70c3c9c2f46561149f5655a2909ee1bdb7"
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
