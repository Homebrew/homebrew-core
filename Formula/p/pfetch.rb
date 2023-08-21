class Pfetch < Formula
  desc "Pretty system information tool written in POSIX sh"
  homepage "https://github.com/dylanaraps/pfetch/"
  url "https://github.com/dylanaraps/pfetch/archive/0.6.0.tar.gz"
  sha256 "d1f611e61c1f8ae55bd14f8f6054d06fcb9a2d973095367c1626842db66b3182"
  license "MIT"
  head "https://github.com/dylanaraps/pfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a91953275ab9b2daa26d9ffe6d6f60b5ca3ce5d556223d24c1020aa9e8285ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a91953275ab9b2daa26d9ffe6d6f60b5ca3ce5d556223d24c1020aa9e8285ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3d84a024e20f9a85803389150748894f9a9dab94593af5c0ee3967a82ebe55a"
    sha256 cellar: :any_skip_relocation, ventura:        "7dfa1cdbfc450e489c88d72808c87de7930ebc2cbc5da51c2be784eeba7076c3"
    sha256 cellar: :any_skip_relocation, monterey:       "7dfa1cdbfc450e489c88d72808c87de7930ebc2cbc5da51c2be784eeba7076c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e5ceb26959ab4f137221f87eefe0ba1912695cce887b30f2e4894c699d86261"
    sha256 cellar: :any_skip_relocation, catalina:       "f93914feee7f4e3cda77341c3bddf2cf51eb4b2aed01f6ace771db75078da570"
    sha256 cellar: :any_skip_relocation, mojave:         "f93914feee7f4e3cda77341c3bddf2cf51eb4b2aed01f6ace771db75078da570"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f93914feee7f4e3cda77341c3bddf2cf51eb4b2aed01f6ace771db75078da570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa6a98908cbd7ac49f1fd4813011ee6f18849130d84b4c4fa3c01282a33c568"
  end

  def install
    if build.head?
      bin.mkdir
      inreplace "Makefile", "install -Dm", "install -m"
      system "make", "install", "PREFIX=#{prefix}"
    else
      bin.install "pfetch"
    end
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
