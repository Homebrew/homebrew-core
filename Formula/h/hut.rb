class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~emersion/hut"
  url "https://git.sr.ht/~emersion/hut/archive/v0.3.0.tar.gz"
  sha256 "ca191d663be81000c8ac0e952cd1b95fbded8c1d918d6d89ff08adbcd3d75289"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~emersion/hut", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4678f6bbbf004582480d660e823fccabb64528030dfb71ca379d4c9f90000f54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ba584478005f8de53b4b3e646a7d61e6e44ee5ed142e3ffcef19e7266037494"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e32511a8c27c8e42e9e5b537b4914cc44b22e78f0ed4d0e5a3d6efdc7b4c5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9318d5f0f2701ae33713be03fa3a3f22a2cfb13873ab9edd28e62402833e76a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b50c30282d25e16b353fff4f9afb387066a3ef7705cb98788dcabd3fc3a3cab1"
    sha256 cellar: :any_skip_relocation, ventura:        "22b1a69da5965fcdf647300a4c7e000c9eafe605b0f76bba0a3fb5c71314d001"
    sha256 cellar: :any_skip_relocation, monterey:       "b62604f19b5a55267369d30c6a52a41577cc8a07c56e5d735078a99e728f1b7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "632462d3ae0ac5a0ee446071ad22d86e2437b827905e0f2d56409b1370706fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "964dd7336e327978f442dee45c28874dee370b40e1e0d43f526e0551210cf157"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"config").write <<~EOS
      instance "sr.ht" {
          access-token "some_fake_access_token"
      }
    EOS
    assert_match "Authentication error: Invalid OAuth bearer token",
      shell_output("#{bin}/hut --config #{testpath}/config todo list 2>&1", 1)
  end
end
