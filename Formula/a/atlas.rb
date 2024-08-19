class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "00790c217a0b09a2bd857f3d277b289707c85cda7a73f88efbe794e697344fbd"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ed33ccf04fd63fe57c88a8f9ee6476b8785bbc3df95909684f9f4688b7b2ede"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0298667fad775f75b96ba90db8d389b427f06e35dfd84ef24ab49e8decbc8e92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47293583d6a389632c964f025973b943e3753640a2766a2ab1fda724dad11435"
    sha256 cellar: :any_skip_relocation, sonoma:         "76213b542058d243eb8269b26ce5ec55ba8359f2c9d787cf5e1b098287f098a0"
    sha256 cellar: :any_skip_relocation, ventura:        "f9a42319f397f227ba70e49ba1b03026e5a72f05820a5beddee4b7e672b03542"
    sha256 cellar: :any_skip_relocation, monterey:       "f771046416c2ad2bb06b735560676fa05003dede4d514be46d432a3d9ff6082f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31332be21f07c36c85942a7d6f0257006eb7976afc1a66eb600b0a4bb2e837c2"
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

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
