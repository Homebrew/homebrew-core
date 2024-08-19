class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.535.tar.gz"
  sha256 "0d915fca4fb46033ea90aa3a473b6142e8a0e04d6dc1440274e460df1417eb40"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24f9bff8b3823f1bd8b3de3a4cea1c1438b7e1d37e96b40adf4db6445c591cb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52b710b394f3a9b24d0b46a3a60e8b9b49003fdde384ba15ab61293a9a6319d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcc5b031319e1946636eb17ce7f6df333168a620e8a5568ee2d1294a4a36833f"
    sha256 cellar: :any_skip_relocation, sonoma:         "764253fbfccbecb08f5d6071205e9b4d5f49bbb0da24c790be6edce7e1537a97"
    sha256 cellar: :any_skip_relocation, ventura:        "783fb03c5a5b90eceace35dc271eddc575d30d0e38e7d2ba234925b8bbaf9526"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc59677b8c5d512a89ae50d4d23857a0e582921a9ebb47e427857f2cceb2510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b97ac9b4819443283a14ce603635eaf041467cdd50edd29467091c0c28640d18"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
