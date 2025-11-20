class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.55/nmstate-2.2.55.tar.gz"
  sha256 "3b1602825b760fc8f47a6056d5a7d865b1130e538987cb8124a2f12c3364afd0"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "239d3bc46335f745406a8e948e066a2fdee133e130d94ea8e9cb71c348c6e8f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4097a617014610c85e2f1d3a29b2e86f250c30ab631e118f02cbeb795883bc35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "119bd18f3b961a9b7747832049778061a50bdc0e4c59774e2bf215283a656d88"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e62302ff8e8bc44afbcc0a64c860854c2b997d563fb647be6b652ed183c44f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaf9d28b6de3235cb6a9e83f592f893a7a30199c0ee5f38c2123df6ee98a2037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8450c00d6dda068fcbad807af17da8b1f94658e643235dc70315c35448b9183"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
