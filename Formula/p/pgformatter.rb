class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/refs/tags/v5.5.tar.gz"
  sha256 "8ed79247afe41c145f6c5f3fa82d714e5fd4a9c20b5af0e1c817318f73fc7894"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0e7dbf0cda0abe59042912f4d489d53724ffe2a3f2a32ef915e948922936f2b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bf3d26c14d04d969ffbda591452fad5676f730279e946ea83bb7b26d8a72eb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f55a58ffba124482444519c77f9e29cfab2bb7148b78da263eb20f64a3a184c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f55a58ffba124482444519c77f9e29cfab2bb7148b78da263eb20f64a3a184c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19b902f507e8db9da9f1c17367a4427edae7a92cf5a935bcbd61cced35803129"
    sha256 cellar: :any_skip_relocation, sonoma:         "dba88452f13c2be2c123bf5d26ea45d8d590ccc96ac0688549b9dbc609634f2a"
    sha256 cellar: :any_skip_relocation, ventura:        "5ed298cd9259c04e657f25ba10211677c940c568212188af3f1af11c960ece6e"
    sha256 cellar: :any_skip_relocation, monterey:       "5ed298cd9259c04e657f25ba10211677c940c568212188af3f1af11c960ece6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9bc5a12c9188639e69b5aa6c418e0f16005fe60643a7dd23fc2d9ad117352e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "186f7f4b0fe30734daa469c0432147d25295c6c8e6719ddf821679ff33f81c32"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
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
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system bin/"pg_format", test_file
  end
end
