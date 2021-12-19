class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.35-r6.tar.gz"
  version "6.35-r6"
  sha256 "f4c0d444da64b2aacf627c363e898897c69cbc4a42e76a7570ffc252ecd941be"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac1cb08b86f4c562479c2a6116d1d352802fcc6ccf31364ad783cde9efe0ffab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5acfe613a88a6e7a969e6b24d8bef5cbef31a22fd14d8db60630177759b5c64c"
    sha256 cellar: :any_skip_relocation, monterey:       "ce002fdc1c120b30db9685479c9bc51419a33731b168ba01a8d92b0393b1d48c"
    sha256 cellar: :any_skip_relocation, big_sur:        "361bfb044f663c4baf8c391b3d6ebceea9604edeccfbe9543cc6ef8100ba078e"
    sha256 cellar: :any_skip_relocation, catalina:       "a56be61e66de57d70e67b07630dd8362209dfc6f24f5797a1f1c3b27dbd8e203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c65f473b3a41f07535950c37b0adfe3011cbf60a20888e5164655180da6aed1a"
  end

  resource "homebrew-test_resource" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("homebrew-test_resource").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
