class PamReattach < Formula
  desc "PAM module for reattaching to the user's GUI (Aqua) session"
  homepage "https://github.com/fabianishere/pam_reattach"
  url "https://github.com/fabianishere/pam_reattach/archive/refs/tags/v1.3.tar.gz"
  sha256 "b1b735fa7832350a23457f7d36feb6ec939e5e1de987b456b6c28f5738216570"
  license "MIT"
  head "https://github.com/fabianishere/pam_reattach.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "470ceefd11808433f82347c1ba80e905d0c5a4b1076d47efac15692b0f86d34f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d220980d0a233aeac53fc39fbd2eafcbf7cdcb9252b9c7bf24066e3dd6b0dda8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceb022b08c5d64cbc3250a227b2496dc4181854fa4d7b90faa98efe2e31b091b"
    sha256 cellar: :any_skip_relocation, ventura:        "d71f187aaad7e98ffb0c030802be6d4c73f245d399a52159701e80a424183622"
    sha256 cellar: :any_skip_relocation, monterey:       "671f461386143302144a82d67f6b1ba1073753f5c6253b8005cfe1eb1918e861"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c40906d18c53054708a408e42f6a86d5579bd853bb69702507e659d0e7ea2ae"
    sha256 cellar: :any_skip_relocation, catalina:       "1ca81cd2502742faa6d88e1345c1c42f5ab401053a1aed3c38434945ec119941"
  end

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_CLI=ON"
    system "make", "install"
  end

  test do
    assert_match("Darwin", shell_output("#{bin}/reattach-to-session-namespace uname"))
  end
end
