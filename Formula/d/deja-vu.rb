class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "9cb615c4b5e648f0d2f5dade3f02e49c653a0b2319a2117532d6d3ecc231804c"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "956b66cdd2338a53000f2e6315c3d7509deb993c89e30bc129d7036bafbb80dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "956b66cdd2338a53000f2e6315c3d7509deb993c89e30bc129d7036bafbb80dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "956b66cdd2338a53000f2e6315c3d7509deb993c89e30bc129d7036bafbb80dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7e49974618d7eeb8238c9fd0f1804a4718a309af2a1c450d2550c0046943723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73669c619405eedda605b6e4733ac382570140c997c08133173ba84ec6cb6e12"
    sha256 cellar: :any,                 x86_64_linux:  "bebb1461acac508e615a26cfa53a513086309b96424bb6f702899a97d692c762"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end
