class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ab15ecd8ad713ff8edbb3cdfd6025417ee3bc539f1594431ed744b0b16102e55"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5f2097d31ddefa63bd8ff6c37112d164c639d85096bf433d0983129d9795396"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca356bca17f03f6246cd71dccb179fa1767077db489bd0b1c437c1fa76a9270b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04741f004b5e51d6b205ef20dfcb900ea6ac951a89944c6375b4c2942fa5b41d"
    sha256 cellar: :any_skip_relocation, sonoma:        "495dcf514d848e5fac7e92565e523bb9b4a9a1bc98ae70ff7a7e57d76e0f75e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbeb0003802e61293bc9622a90fa18761f5980a6754392acdba835e998f4b92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b69686cdfb127d6653aebb8bc94b22b7d2ad50dae95f7bf05255dcd0ae8408f"
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
