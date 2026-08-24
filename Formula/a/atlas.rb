class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4d83772262864d35f8490d919eb405aa47c44d5b703496494b3141c691ed8987"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f6dc3521bb9de88fef45eb64be8b5c7a6ff1f7fc8120b7e90c4758912765555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d01113790b610be82d82efc4bcc5fb0a5c9bf8553a0e1154ef8e518b0396e984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a5255f00a550aafdd9642266412d666ec1b441f65370d8e338e0259fccf3a69"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d244cdf73ecb10be682213651d08735facb0faaeefe414d9c29764653f9f0ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6294b9c02d388b4b78cf163795183b01da18d6786be2a3aed934b500f63d106"
    sha256 cellar: :any,                 x86_64_linux:  "68750ba796bd2c41fffe47de96df942eef3a154dd3c9921b785d2b7d38525612"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}]
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
