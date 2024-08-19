class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.58.tar.gz"
  sha256 "fc6446739f3c1a7b2a3ce4ab4dfa4ee49483cf5e85352b5a44cfe980fecd1656"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25445b772214e86c175f2d98515837ff2a5b21ae9fcf8f26dab7d791ddc16b2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e004c5c4dfb2efb852553ca2ee13a0bb29916fa1ba1e14ffd6677307bc0f134"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2384e6443b8f36ab368f23ab4974ca0f6d34ac5db9247c509a64a33e3bb61574"
    sha256 cellar: :any_skip_relocation, sonoma:         "9511d0fa188eeb7767ecf091c4b5fda8b556dfd83c67fe6641ee24ee7ce2b1eb"
    sha256 cellar: :any_skip_relocation, ventura:        "25aa0111f3f36efb1013aabc84c83cee585862e6fad5b98ccdbddc79fb9abf64"
    sha256 cellar: :any_skip_relocation, monterey:       "cf30fbeabc4e3cbfeca3b8e52ec0f07d6ed72514d4f0302845aa97be2aec3f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ecfb1fcbe62ed99b3eb55d53b5e11a3c20676d821f2c9de905c606b6f3b2300"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
