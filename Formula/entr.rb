class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.2.tar.gz"
  sha256 "237e309d46b075210c0e4cb789bfd0c9c777eddf6cb30341c3fe3dbcc658c380"
  license "ISC"
  head "https://github.com/eradman/entr.git", branch: "master"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56f8366e478c99ffb084ac134a200c4d32be0180269efe00cae21595a32230f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "534fd8c1d47267ac699b82147088e7553fcc140f954bdd8e71fed39445a23fdf"
    sha256 cellar: :any_skip_relocation, monterey:       "e98f5922ee52c2d99169c6f950d6fdd678bad77f8649a5ab1e78422aab816640"
    sha256 cellar: :any_skip_relocation, big_sur:        "e497cfe6f336396b7a7b112764c4846ed8e40d1123f1b9e823a642253a562d81"
    sha256 cellar: :any_skip_relocation, catalina:       "9d0c6a219c54e065abfc84b4f0c75c460288ef81dbe889005014f1ed699d4c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038b376d5d99370b2532bd6cfdae9a7d01b644c196c110c3371da799a24e0c98"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath).strip
  end
end
