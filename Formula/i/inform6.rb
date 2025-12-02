class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.42-r9.tar.gz"
  version "6.42-r9"
  sha256 "687623aa37484a7c94c6daee0c3583d1c1c43b1069be6dfe4df371b46a1f7b34"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/indexes/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23de328d6094a8d29dabc24ee248b523ffef646e48fb774e9f902e26ad2be930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0e9bcb817772699fa17350f2f8566a74fd39e87d1df23a00a2c4cc22acb19bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ef1beac990817bdb422ec6c4aa4c50317c7314f16e80dd5c7256bf103a08e64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c0669fd9cde57b7b9db047c59e99d601d4fa4e77d65fa925b0308d2a4d6c114"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd427c44738112ba42b586423a922612bc0677884f3ebedc64f8ce352491be9d"
    sha256 cellar: :any_skip_relocation, ventura:       "3401036cb12cd917e8055537d42f1f6bb9ef900bbfa49b9503a36094afa9e702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "026cfd9a2b44301f62c53be35ef49fc17f82d3b29b92c34202c66dbe431c6a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa455d5776636b51c49a7a35821ef12ac14268bf5ad5d70ac66adb49f6d95924"
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
