class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.42-r7.tar.gz"
  version "6.42-r7"
  sha256 "63b1266ce43db3892281525f51699d895ef0764084e87ad64f87f7720bd0bb38"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9a851576dd94e3d4277496c9dfce363790e23ce927653b6e4500e1acb4c04c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "014d7cb3a7c88810a099a50e91ef2643caf5d7898e540ea8cdd9552d3430fb75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dbe557b3090c8cef2d83e6a5397fb10e341dbb897a57ae546c243342340f23c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0e8f33dae9540199a38198a65484e6949d36da6dc976001e88f0bf23aaadd84"
    sha256 cellar: :any_skip_relocation, ventura:       "7a1288c1469e66ebcf1fc251683d9319f43f021d1ee13a22dacc929625340696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c389f1f2e3a3d587fa5ad37e84699c3b873b42758f2540d4da4acb81fa8e1d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cb35901e4cda912ae55b5dacc1c0790c5649114fa43bdc91416ffcbc3fd8629"
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
      assert_path_exists Pathname.pwd/"Adventureland.z5"
    end
  end
end
