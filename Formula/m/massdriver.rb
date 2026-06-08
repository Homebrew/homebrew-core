class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.1.0.tar.gz"
  sha256 "95fd39d3d0c5241dfe920b1814d33dec9870f993dd9f5ac37e736f8a3cbc0414"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f8743fedf505263a55b743f3d37d9f0b7aca82031c5b809d2d22e1e730c7884"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f8743fedf505263a55b743f3d37d9f0b7aca82031c5b809d2d22e1e730c7884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f8743fedf505263a55b743f3d37d9f0b7aca82031c5b809d2d22e1e730c7884"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c2b919ab78e509781e24deada045de856401b039c25ae221b89932d649715e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a1c89c66cad50e5b63fef544dc6be489efe5f46c25f093154667c797d7236aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "926d3a5740c6d57846dac7644881ae665885dbb311725ae6a1e9f9971804a7ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
