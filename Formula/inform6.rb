class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.35-r5.tar.gz"
  version "6.35-r5"
  sha256 "4c5aa421b1c8c944e43142e1cb6b3c1e5ad7b03589fa470ce3734298ae61eaa8"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2a158d3ac51212e117cf6a2513659d665d5f80a1c783649e875ae1f3b52c6ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efa2ab2fcbd736f762b1439e65febdf7eef588fad71bd8e11a53723e9553bba8"
    sha256 cellar: :any_skip_relocation, monterey:       "465311522f60b2a5d28fbe816d4f56497584164032e50a46e651dacf67969fdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "765942a2b937d9b43bbab8e8fa3d390237d1935dd44edead8b9c54b4c7ee55d6"
    sha256 cellar: :any_skip_relocation, catalina:       "8edd7211435924fdf81edb05720c36ef6e037984e6d4e5f0b165236340eda8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a33f80c3d186855817dae7774121a878a349e46f9c8a7f6cfec3b1d6ebafb1"
  end

  resource "test_resource" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("test_resource").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
