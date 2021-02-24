class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v5.0.tar.gz"
  sha256 "1bb5b2e2b4ca27789d617456e1a0301a0c2e3c4a32f93ccbf71bdf1ff0219217"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0ed20e16efad36d589a80538e78ddcfa9b71f02b56bf32f9415e803eb8cbd537"
    sha256 cellar: :any_skip_relocation, big_sur:       "83a175025f66104c66f735201a15852b8b7e210d8dc5185b004822f0032fdd9e"
    sha256 cellar: :any_skip_relocation, catalina:      "81895f455d9c400ed7de8e8cb2ebc1fa55147be0fe6cd4e9faae3f61a44b8040"
    sha256 cellar: :any_skip_relocation, mojave:        "330e956df52c371e9d403e3eb5b9b46a0a5e415d1ceea6156fd2e2036aa046e4"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    prefix.install (buildpath/"usr/local").children
    (libexec/"lib").install "blib/lib/pgFormatter"
    libexec.install bin/"pg_format"
    bin.install_symlink libexec/"pg_format"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
