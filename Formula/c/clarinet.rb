class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "8cd4eb4f60c0e933437318a41d3d9c3854d6d4a3488c35c873508f11aabd270f"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25851609641d7b0dbe95ac7e1b57571a0595678fd046881e9fdf22d826da60d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e59203fe15e7a5b95390c100258bbcfc08e2979b97b30f5d6c9e2d203cba613"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ade11d84800cb34ac0fe547117958bd31f83d0a0b819fcd605920e61c644bf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bccb8117c356bdd971ccd42c5668fdf2dc729f4c6207bb6097e1d66c4ea74e4"
    sha256 cellar: :any_skip_relocation, ventura:       "c2a9f00c1187028f2de8e1e57066acc4ee43073bf292bff6e8f8607d65866c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d3e5421565609dfaa4c45c58cb69a271140f3df81db437f5f4c0b5a817119f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbe97ee77b11608e8d194d0ee37af27957472a48114c31748a3d175810c53c91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
