class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.44-r7.tar.gz"
  version "6.44-r7"
  sha256 "3e1f94e5c726f5f59cf086756dc14e66a3fd281ddbac75ead611d45aa57e4bdb"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/indexes/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8338005c9a548fe8dc0c5c0ae68fb39438dc9ef52763f186c901f474cc5f8b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f4462d536047ff5b3bcd1b5ecadb542bffd177077ca091074a3ba8a2e2bf7cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7382ba4b5b947e457709b02cab9d4c6d927ea3bcf5ca6b45dd354dad5584e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "744116b28007f49c72285b5e474ceeb2848fb9853ad9c22e8e831a6121ccf11d"
    sha256 cellar: :any,                 arm64_linux:   "4ddc76b1a88be24c0819168b2013b48e730cdfa0bffc12f26b8ea2c580d7e7b4"
    sha256 cellar: :any,                 x86_64_linux:  "c6c535ef94ed46182ab09a305a13cb6312131214b1f60a888843be655685ac50"
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
