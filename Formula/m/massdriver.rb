class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.4.0.tar.gz"
  sha256 "a19a3709b39401eaf236323383aae1de1641e06f3d09b7a51b4c262a2ee2a4e6"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36b312a93d8805c49bf684257e374a0c382953840021e73029c136615658aaa7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36b312a93d8805c49bf684257e374a0c382953840021e73029c136615658aaa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36b312a93d8805c49bf684257e374a0c382953840021e73029c136615658aaa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a762206a536c568fa46e384bd2a5b6be558cba57dd4abafe72d70ebd7357660e"
    sha256 cellar: :any,                 x86_64_linux:      "6f0b0bf0e152b4b135c60b11f72742c730ab0b34c8260d01f6dbeb19ba007810"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
