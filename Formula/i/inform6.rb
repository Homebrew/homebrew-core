class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.42-r4.tar.gz"
  version "6.42-r4"
  sha256 "47f1b37b13691c29809a25f3099c04bf5d7b29ae29d91f8fede40f5bd0b53575"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cf6f12d3a12ec8cbb0def152da5d97c7cf7669e8214106691410dd4e63f5d66d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "559f2499ad8c01a5bd8865e21dec4827963d84360535f44c0186231af64900bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18524ca09049b3e02e9d1ef278a51e75af89fed4fe51618af73e1f563ca514b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cddc6ed6885cfd64651c89746024d419c0fcb2aade6a8898ca0499d75325ffad"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b2be450b8a181a9632896c7ffa3d165776e038c7d646e5b71bc2d7a41153035"
    sha256 cellar: :any_skip_relocation, ventura:        "390652934959d90862a31ed5b6406738f321975d346ebfe56627b313b31505dc"
    sha256 cellar: :any_skip_relocation, monterey:       "4c6ade168027ba1a2152123f8c288418fd8fa07c3c99ea0cdc258fc25ea62e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef7742bbf2854576904ccb28655b7af1fea66086ce33e305f6bc946510038b12"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource "homebrew-test_resource" do
      url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
      sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
    end

    resource("homebrew-test_resource").stage do
      system bin/"inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
