class Jpdfbookmarks < Formula
  desc "Create and edit bookmarks on existing PDF files"
  homepage "https://sourceforge.net/projects/jpdfbookmarks/"
  url "https://downloads.sourceforge.net/project/jpdfbookmarks/JPdfBookmarks-2.5.2/jpdfbookmarks-2.5.2.tar.gz"
  sha256 "8ab51c20414591632e48ad3817e6c97e9c029db8aaeff23d74c219718cfe19f9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13bd17ff83235a1e154915b59a521ffe910ecb2ca4ae837203441813b32eb176"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13bd17ff83235a1e154915b59a521ffe910ecb2ca4ae837203441813b32eb176"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91470e2dbd04216a27d182e0645399b3460744315b564f2a6ae5b86d76da2b14"
    sha256 cellar: :any_skip_relocation, ventura:        "f059129d0e91d4b1791c25c19bf52e20ba971b34167af63993e3f4ae9667ae50"
    sha256 cellar: :any_skip_relocation, monterey:       "f059129d0e91d4b1791c25c19bf52e20ba971b34167af63993e3f4ae9667ae50"
    sha256 cellar: :any_skip_relocation, big_sur:        "849a02893bc8fea3cd3813695f7c6d30598e53dccb4bba7933d745d221258a24"
    sha256 cellar: :any_skip_relocation, catalina:       "849a02893bc8fea3cd3813695f7c6d30598e53dccb4bba7933d745d221258a24"
    sha256 cellar: :any_skip_relocation, mojave:         "849a02893bc8fea3cd3813695f7c6d30598e53dccb4bba7933d745d221258a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a55444d161c8b6a7186b252fd79e2f63831bca8f54e4a0d4633c76988cce96c6"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["jpdfbookmarks.jar", "lib"]
    bin.write_jar_script libexec/"jpdfbookmarks.jar", "jpdfbookmarks"
  end

  test do
    test_bookmark = "Test/1,Black,notBold,notItalic,open,FitPage"
    (testpath/"in.txt").write(test_bookmark)

    system bin/"jpdfbookmarks", test_fixtures("test.pdf"), "-a", "in.txt", "-o", "out.pdf"
    assert_predicate testpath/"out.pdf", :exist?

    assert_equal test_bookmark, shell_output("#{bin}/jpdfbookmarks out.pdf -d").strip
  end
end
