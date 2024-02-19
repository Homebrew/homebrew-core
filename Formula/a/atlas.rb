class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "e3f8a366ca7836af457798c025be4119f40ddbef13a38fb399510cd01fc8491c"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8936ad0e85e9ea913cda03e544e1fca607124f394cc9edff8f523c501b9258b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7108c1328ada4b9bc6a874bdb673be620199242d651e21d1276b02a577e971b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d1ac05344abc34226e83c0a41c42e3cf4c35979bee75b070a8012a256cd4279"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8121fb70f01a8d0fe4f81192eacb2fa00081ca434979cdf4a21e1c101d8abb4"
    sha256 cellar: :any_skip_relocation, ventura:        "fe48f8a58fb384da778638d41267e4ac7d61afed980647106e0c043305f31b02"
    sha256 cellar: :any_skip_relocation, monterey:       "1a3a3db3fe44b9956041fc5ce1f79cf4c661c80ea8ec34c951713be43108707a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3754fc8b667c793db2a4a75d3bbe6a725857e2c50a3569b5f3c92854609a43"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
