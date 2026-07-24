class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/nolabs-ai/nono/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "eca9a027cd186e595824c99cd8bb88467a03619fb793ef7c249993fc771fe1ce"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f85750a135fa10a2fbac12ad3d9b5b788cc9c8ca5ae1d9fd17ea6323b37a0a3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0983ed02507fcf1126531d0321af77785df19e55978aa1b2911456d37f8c4b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7fee83026c4e4997084c66ba61943f143ff24da8f6c815ee77a595293875f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c4c85d0a450bd86a4db75d7cf9c93ccba2434bbc170591422a896d0f7136bb"
    sha256 cellar: :any,                 arm64_linux:   "86646363b5896349295fab67a896b21d4fea62737e9276b8619093001b09f793"
    sha256 cellar: :any,                 x86_64_linux:  "f28ee3478d31cb97c3bce8fb9e4e5b0ec3fce7fe93c946d16238219b7c49de2b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
    generate_completions_from_executable(bin/"nono", "completion", "--silent")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
