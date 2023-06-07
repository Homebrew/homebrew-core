class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.41-r5.tar.gz"
  version "6.41-r5"
  sha256 "26c2ee7d19aa52627889fd575118bdb304b4ba9c3e1e3f36ed3dbb03da8300d8"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "011c6bd80bed2678ee5c138726fbdaeddfbfc214c6b1dd08326721cab84aa8c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5168a0f72970944e1400ce4901da97bb235568b9617b8fd6b395daf80b7d417"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8aa5e1ddd554be924428b11b1c112e8eb52fb7e81e0cb674728838a316471c4"
    sha256 cellar: :any_skip_relocation, ventura:        "5d0fa0df9d0b265db8ab958636eea5ec0d22d701cb54b473745f602c20ef9efc"
    sha256 cellar: :any_skip_relocation, monterey:       "6ba1775186aff293cfc8c37512f71faf7079a3d69cecffa51fba39472e6ed26e"
    sha256 cellar: :any_skip_relocation, big_sur:        "406e7520f408ec324c7a6ffa2f10996b904dab21b511806a58deacc4f501d233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f5fbd928ca9684584897efdca03b35f17dae28b9662d5bebe17a89b7c6f488f"
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
