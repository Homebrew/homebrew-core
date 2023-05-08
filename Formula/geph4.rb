class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.8.1.tar.gz"
  sha256 "3348096bb384a79af59446a19c31461ee7789fa6e9aa9602fa54432de6a4f6f5"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d086f6a19755cbcc56c8d3fef406e3b749fcc0ec38898bb1a9709dfa94bcdc21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ea8333c795e4949429a3e82a0d45f48f9b4eb795ab39af4aec0eca5f7f7c47e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbae195ab4a6f0cae7df1b958c1ffc08187a1286c7699fb7f558715d3876ab37"
    sha256 cellar: :any_skip_relocation, ventura:        "1186e5b8430adcc4ce570809873e19c193248b97e30d93e3a70398ec374ea957"
    sha256 cellar: :any_skip_relocation, monterey:       "e2d793f028ec8bb9f142dba39f793485a58a30c5e3d9d2963541bd5c63ab5e49"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d7cbf06ad31165f399524e139ceb4584774c2f20d49586e5066baa600547aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a988f96d918169ca64d8b2de0144cb72bc4b27af7a2af6584383a307beb8e8ee"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
