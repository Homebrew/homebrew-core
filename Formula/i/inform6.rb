class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.44-r1.tar.gz"
  version "6.44-r1"
  sha256 "a81f4f5c967818943fc11fbf3b080f15f2f202c19cb13ee7945b30aaec800b5f"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/indexes/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72f28c28aa810f6eb630394225b998cb106427f37e05576de94b3e78b0deaa50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "333e2878d4083b34c7b3a6072984377ad78f7ac872a9d78bdbc2037c201c3527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da067ceaa3949dc4ef29764157d85088cb79c28d4d6463f9dd343c4a79ec717e"
    sha256 cellar: :any_skip_relocation, sonoma:        "307ced082003774277c5d0d5191b88917ee840c38dc3cd1d1953e4496f590fa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "060da84f7acbd2504a200b23c9111595d90c0f9a045d0a0c4889d31e65518b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a64513d802ddc9b6e61028acf6edd7aaed51acb10938e8df3d231b8783dc3af"
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
