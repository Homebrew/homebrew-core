class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.14.0",
      revision: "33528d701a0c903dd4db806a2bc091a5d1a19897"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1c3c7a5420b6b437800ea39fe42c26a491d927415dd37eba6c3c6893997a3c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17fb3c062a4c718cab43e6584e1939c0d77c82be17d9e892058241a1c09a5d6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a58042ad59f93c6c6a041e1a75aa4d793aa69528e94e43d0117ab69d9d3d1058"
    sha256 cellar: :any_skip_relocation, ventura:        "f3ff8ec1e83f285b05337e9a6567966fd0db08aa25c1b0d44865626b00451107"
    sha256 cellar: :any_skip_relocation, monterey:       "845583622cbe3f37c648466e6c0d05beeffd9235350b44c359ca23820b5740c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f9081b895786caef324c88804547e971d5d87256a27089b00205beb8728fe78"
    sha256 cellar: :any_skip_relocation, catalina:       "7fc0c536b29c237b5c4ce5b270adb6bd435700a8b99184b951038a4712b0dc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba945bc95056d922704941492c445c414afddbe3d875d459a8081a98e1e23387"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
