class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.42-r6.tar.gz"
  version "6.42-r6"
  sha256 "495b0886f95654ad145a0c8bf3962eb9e13dd8243d44081a501aee20ecc6a30c"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08efdc6b03b5d780921e28a6b2c592adaa4ef611f002f832185bd06868daf96d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8add27532fbcf6b1f77212958581cb96fb58197ae6822e0b029b124c6187ff93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "788226d2bab59288932ae188f1fad70763d15e0cec48c99a29818c5448e9afd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c6e07b2ced98ce5569037b148cc7f891a3f7f0e72ad6d10012b678fc8ec57c4"
    sha256 cellar: :any_skip_relocation, ventura:       "d274681d031f1238217f95ab2ebfc3405b1fcf419a16e624f9ef7ef270c6b07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26e8af3f4de94383537d8a8f92dd031bea47a668a27f7617feac3941bc7d88fb"
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
