class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.42-r2.tar.gz"
  version "6.42-r2"
  sha256 "ccd9bbcf69c997168745c67b01df2dd63656f7df68f56147ac49ea94e24b764d"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd251af4f30631e7948546274e3e54c20594466c0eaf9a157e77bf9b8b6ab3fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed4632138f088a72076fd213458511ad020f41e34ec5a52fdf125d613fcff0c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfee2a01fef018e0ded364fde851813550345b2a10a07503dcfdfc39f6dead06"
    sha256 cellar: :any_skip_relocation, sonoma:         "55f697eabc41dac5c246416121e93c05d18292f3984c95abe61a08766958f34b"
    sha256 cellar: :any_skip_relocation, ventura:        "0b730d75bb12d4e0a770ea05a9f5ebc5dc20f0b20e4d8003f723d68060510525"
    sha256 cellar: :any_skip_relocation, monterey:       "71d0e627373770f769aae0e57c86288a6990f6e1f4c11bde862632f683d4c7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8484ff6dd6855be928e8f618e04cbe55c237fe05944c423cabe7683101ac2a81"
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
