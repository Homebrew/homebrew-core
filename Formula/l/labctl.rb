class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.57.tar.gz"
  sha256 "eb062d09ec5c4e1e97132f52ed2b03b64fbe46360746cd7f0034f4beb945ce61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b206180ed5dae07e773d487cfe22d5b031b2b00ebc5964e3d9cc3278778901d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b206180ed5dae07e773d487cfe22d5b031b2b00ebc5964e3d9cc3278778901d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b206180ed5dae07e773d487cfe22d5b031b2b00ebc5964e3d9cc3278778901d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc7301da166372b587bc9968b4982c1cc156890c4f4293668c7c00748f28e0e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6944444f32359de7b3566e9d01cf447128c1bdfcb47bf8d320ee3d206bdf631a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f6ff84f45930e667659a12d84bf56505199bd9762c87ca68f0b5c72345b752"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
