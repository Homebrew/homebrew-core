class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/79/27/765447b46d6fa578892b2bdd59be3f7f3c545d68ab65ba6d3d89994ec7fc/git-plus-0.4.10.tar.gz"
  sha256 "c1b12553d22050cc553af6521dd672623f81d835b08e0feb01da06865387f3b0"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef42c82b5838b88df701124a18379ee8a14f2c88e365d67746498718180d373f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a11df5d95977ab8883a8d9c1da8de49d3961b2af8e603541bb89698610152d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a3fdfb6af0edaf6640810775fdf0d3050ae8563670cdf179da8dbf1ff57dbe0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bf2840e8befe23d5936e35a1b305e668cec3ef32dc3b0871c63f37cda9deafb"
    sha256 cellar: :any_skip_relocation, ventura:        "63be2ece5b241070a38b67acb67b793aa6a9bd826851ad727ae14bef2b5cd71d"
    sha256 cellar: :any_skip_relocation, monterey:       "b263281a92699af45da8bb2d454c20de932bef6ff4767f725444c8cec51b824d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925f476b99a1c63af07210194cbc72f5caae685b440b70ea0e5530b6c2befc38"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "testme" do
      system "git", "init"
      system "git", "config", "user.email", "\"test@example.com\""
      system "git", "config", "user.name", "\"Test\""
      touch "README"
      system "git", "add", "README"
      system "git", "commit", "-m", "testing"
      rm "README"
    end

    assert_match "D README", shell_output("#{bin}/git-multi")
  end
end
