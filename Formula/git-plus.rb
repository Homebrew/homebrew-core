class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/d3/2a/c573678f7150f35305f50727bcfd41edf1415fb1e523860f0f0788d99205/git-plus-0.4.9.tar.gz"
  sha256 "b9a9dbbffc030a044cb7d9ee46b3fe1b683162cee52172c7349eda8216680ec6"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1df39b9bfc960ca8745fae4a881b5d976b4056b6381440c2979ede17795cd0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1df39b9bfc960ca8745fae4a881b5d976b4056b6381440c2979ede17795cd0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1df39b9bfc960ca8745fae4a881b5d976b4056b6381440c2979ede17795cd0b"
    sha256 cellar: :any_skip_relocation, ventura:        "f84a2bb9606908c30040db300734c023394660e0ffb6229939be0c4ccbeb02a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f84a2bb9606908c30040db300734c023394660e0ffb6229939be0c4ccbeb02a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f84a2bb9606908c30040db300734c023394660e0ffb6229939be0c4ccbeb02a7"
    sha256 cellar: :any_skip_relocation, catalina:       "f84a2bb9606908c30040db300734c023394660e0ffb6229939be0c4ccbeb02a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9200ae7d572a148f00ffbbb30cd1ce12c56f2f01a4b3026b107aef52765337"
  end

  depends_on "python@3.11"

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
