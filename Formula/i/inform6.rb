class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.42-r8.tar.gz"
  version "6.42-r8"
  sha256 "0a8dd735caf42c319e1184f12059aa4ec68a9b8ab95692e956c4cd9c91d45fca"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf50a43cf6ad1bc5002808d0d54881f67ac354b4bcb8a5f667dc91f541bfaa29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c56ad26a5f0b7ee5b1546a2323fcc1011727219c94f85d37e3c1f56c56218c9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b047ddfaa9d4a2ed217f9db0848ae6ed4f81da101f483eb2d8ef181845114739"
    sha256 cellar: :any_skip_relocation, sonoma:        "151021e2da3438b0fd19a89a5c11a0368bf64dedbb08dc92d32bf97254409dd2"
    sha256 cellar: :any_skip_relocation, ventura:       "6ceed800af41932e57fc4f44c9fb35fbf68d112e67509cb46355918dcfd4769f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd487ca3d4116c71e15bd22d38ee373a8b1bcd2e45ba5d042689b13c23ea6567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b36578068913f30bbe928390054a167147038167d3b42781e9e066e5695a6f0"
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
