class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "0968b685458da1f414d3a8d09fe7ee9a3359906fade36fe787369c40d757f2fe"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6f391e4824dbf91b57742206f9c6210c8d4a6e4962719504c16e680b8a64815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3949465bbd1c8c3ae313ca9916b52bfe60c8e270b2ac34005ffb109eae415b03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5097f150b2fa3b6b50d44fe4110622bd6bf195037fe881c4815a3083f45ce2f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a18a05a3a26805ac58db6707848ad877e4fe3900d0a689487d426f14c9fccc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88a3d2d7b3383221370c33e8dd6f6278a8318dd8cc3dba0bc419a3076abc8d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa3f95c826190afa42c042acfba90fad7600ea15f6692a2ce20f0537e610f72"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
