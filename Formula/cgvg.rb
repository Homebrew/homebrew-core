class Cgvg < Formula
  desc "Command-line source browsing tool"
  homepage "http://www.uzix.org/cgvg.html"
  url "http://www.uzix.org/cgvg/cgvg-1.6.3.tar.gz"
  sha256 "d879f541abcc988841a8d86f0c0781ded6e70498a63c9befdd52baf4649a12f3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9ba7bdb16162f2ad7cb462cef5ad939ea15f93c759e272bc9fdf8eb9b1ad8df0" => :catalina
    sha256 "9f1f8ad71fda5ecf4341a28420e5c1629a4b5285edb5d40fbe13ace1965ea239" => :mojave
    sha256 "05dcddf73d630ab2f67e00ea63af02f6b29b503c2e938829daa67d7f619fb556" => :high_sierra
    sha256 "12b8a6abb31e2e8d7ba044663b33990884ec24d1b0c0776901480cbecd47113f" => :sierra
    sha256 "a8232322755cb4c369193dca37fecb968ff689c6463611680e12f216f46507c4" => :el_capitan
    sha256 "de0c8b890aa68670097790093fdceccfe1d69598c18ea5385069efc2f73a3c5d" => :yosemite
    sha256 "d05cafffec1008fff858f9c0210d37d4d081aa34d8a490b968a8b824866a69be" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "Homebrew"
    assert_match /1 Homebrew/, shell_output("#{bin}/cg Homebrew '#{testpath}/test'")
  end
end
