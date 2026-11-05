class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.350.0.tar.gz"
  sha256 "cb345105b60aa4ab47fc70cf4fcf08594f853803a8a9b3f8dee1675ca2ad6f64"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "595d17b40f5ccd7d5892e52ff456317ef33e122f48c623eda889ffb3d1fb2cb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3fbc2702f6191791302d91d094e707ffd76b375f380773c399dbbfa0bb733398"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8478d8bd58c15bb088e849c3569e50d139ce4c96c87d69aa15ba3dbf9162ccd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99ade9b40334690b503f86adc864cce58a0d1d7a723d6895ebf56de5861fa784"
    sha256 cellar: :any,                 x86_64_linux:      "aaff2b0a2b937b0ec05e494e437272c0fb505c8c7957a779d92fb8e3ea9c782d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
