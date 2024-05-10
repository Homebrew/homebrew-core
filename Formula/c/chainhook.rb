class Chainhook < Formula
  desc "Reorg-aware indexing engine for the Stacks & Bitcoin blockchains"
  homepage "https://github.com/hirosystems/chainhook"
  url "https://github.com/hirosystems/chainhook/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "cfdb9bbb32fb7b2650fbed24fb18f5cea02155100f41f2be6400a566a7b3cec2"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/chainhook.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59f4989624947e81f4bbe801032e8ea038e89f0524091b48bee911601b6ad9b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6dabc099e94c703a85b5df878088132e1b0665b2668f90daac22845e6247f5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e72d8cdd794ad04fb12fc1737cf06b5b47b54a4fdab3092614b069ce1fe4c22"
    sha256 cellar: :any_skip_relocation, sonoma:         "06bf5abf8998bfc30574f37edb6ac5359df30040ddc64359cc0f42be6d24eb81"
    sha256 cellar: :any_skip_relocation, ventura:        "19ab3bfc913f3d38caacb762fd0fd38762730fae9b302b701026140e83b99986"
    sha256 cellar: :any_skip_relocation, monterey:       "c7b17d7a180377e811cd43a4b7a3f64fabdfffdcf62c2c6a1a8a23d55ebe1120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59a2990b99cf1804d32dab83460ebd2fdef6469c22aec982d406854cd4751890"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", "--features", "cli,debug", "--no-default-features",
                                *std_cargo_args(path: "components/chainhook-cli")
  end

  test do
    pipe_output("#{bin}/chainhook config new --mainnet", "n\n")
    assert_match "mode = \"mainnet\"", (testpath/"Chainhook.toml").read
  end
end
