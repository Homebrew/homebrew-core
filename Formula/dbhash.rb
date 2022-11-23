class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3400000.zip"
  version "3.40.0"
  sha256 "48550828142051293e179ffc6a8520f6fbfd82e1cdca78b93792f766cc89b8e2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67196b4b0bd8f4ef8afb47f58c2a183295f8aac8923bb61c9fcb8759b4d9821e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14092f4d2dc61bd11f329d784fb1c8d8a8c728119cbee69d6c3ec72602ed9cee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05d927f54ca338e9e65d6804113d01e3c701ca84795fd1ee91d0fc6bd49ccb8a"
    sha256 cellar: :any_skip_relocation, monterey:       "3735d8e37b13112d47fc95e9a7e6fdc59b124f740b64d5c16aa52c5cb15c45a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a64e2afad390fbdabe843c9d6d817053612edf414a5c1f3a8116273ddeb692"
    sha256 cellar: :any_skip_relocation, catalina:       "bdae7f2044e740ce3ffebb39adaa8bb05a4aec4d966d7c61fb8aaf4452b67b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c19a7aab5170e7d4ce3c36d9e0aa4d4f544855c46c6ab5a276e32f7f6db03b6"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
