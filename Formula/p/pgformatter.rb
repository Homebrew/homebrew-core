class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/refs/tags/v5.11.tar.gz"
  sha256 "563619e13294b3db55d7a98a761786024ea3609d007fa94654a69a7346b8fd67"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba1843b9849b308a16ac7aa0b6ab7f3ffe983614ce231fd02910a420a5b861e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba1843b9849b308a16ac7aa0b6ab7f3ffe983614ce231fd02910a420a5b861e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba1843b9849b308a16ac7aa0b6ab7f3ffe983614ce231fd02910a420a5b861e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50dd65fd169020261191e953a65ffdf4df70565c65808b65a8ea7e78ab8d8bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50dd65fd169020261191e953a65ffdf4df70565c65808b65a8ea7e78ab8d8bc0"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=.", "MAN1EXT=1"
    system "make", "install"

    if OS.linux?
      # Move man pages to share directory so they will be linked correctly on Linux
      mkdir "usr/local/share"
      mv "usr/local/man", "usr/local/share"
    end

    prefix.install (buildpath/"usr/local").children
    (libexec/"lib").install "blib/lib/pgFormatter"
    libexec.install bin/"pg_format"
    bin.install_symlink libexec/"pg_format"

    # Build an `:all` bottle
    rm_r share/"perl" if OS.linux?
    chmod 0755, [bin, share, share/"man", man1, man3] # permissions match
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system bin/"pg_format", test_file
  end
end
