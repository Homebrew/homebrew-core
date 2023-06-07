class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.12.3.tar.gz"
  sha256 "aabd3dd2efb74347f6da0858a2fd686aa18ba373f3d2ba78be676d95a50255d7"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17259db96f914df3b9772d53631dee90f4282522aeee8b1a713b8d08e77e6122"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e9627fde31eb0a570a93afbbf30f240e628a58f9e34c373da191a6109c89b45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af5d918742af9137b236977828f469643f569ad6f2a757a05a57e5176e70d9ef"
    sha256 cellar: :any_skip_relocation, ventura:        "10e05d41bbdc6041bb62e7642aabc21e212f166e1d7fe16a4cae40371095df57"
    sha256 cellar: :any_skip_relocation, monterey:       "3d2519d87491a4e0f5b5aba167263fcfa318f7e3abb45efe4e0e62cca4c134c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e6547b066b8386d4e5f4d5d4f2878452df5b2911221134e6a602ce1f720b29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d0d72ffa7c50506bba0c56a0a2421d6bf832ed798267c7d2aae5a62979d4a7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
