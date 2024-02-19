class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.41-r11.tar.gz"
  version "6.41-r11"
  sha256 "91f15f8c92f4ddfdda7f587f25dbe422db8316ef1a1a53370516b678107e75d6"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cac469d603b339fe28bbb7a14989bfeeac8fb0c4caa375191deee6954f73b43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e47394e4365b91f94cfa3796bfdd7787e31277fbbce09ab5bc7f36d564bcbee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5fa8401a108ee6277f6733333bdee92caaa3be2ab0c633c24c326fe486813a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b16d21c28632680520db57a285517fc0f6278b648c81e111059332fbd41e4cd1"
    sha256 cellar: :any_skip_relocation, ventura:        "95056949a2a5f87324ea6b2a00669c95f46127038d964f215169fcec3ded236d"
    sha256 cellar: :any_skip_relocation, monterey:       "2d009d9a3900ba258012cf755e72ad6fc0031cd4894527e5a7fdcd80f4a75d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae87b2faa46fe713a4b44d5684256b0970bed9b33b47d270936f5617d32b25b"
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
