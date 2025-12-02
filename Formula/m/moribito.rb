class Moribito < Formula
  desc "TUI for LDAP Viewing/Queries"
  homepage "https://ericschmar.github.io/moribito/"
  url "https://github.com/ericschmar/moribito/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "7b07448c6f8f16121232c73f45d8c8c7b59e066f20a00850dde093e724cd98db"
  license "MIT"
  head "https://github.com/ericschmar/moribito.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37034fa0d7d8f39b905f495d15d385ebad49b085045dc6ea469d29af44e2194b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37034fa0d7d8f39b905f495d15d385ebad49b085045dc6ea469d29af44e2194b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37034fa0d7d8f39b905f495d15d385ebad49b085045dc6ea469d29af44e2194b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37034fa0d7d8f39b905f495d15d385ebad49b085045dc6ea469d29af44e2194b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b60752bdc952a103dc312c9ea4f404f1e0b260e5914fde7d810f91a996f31db2"
    sha256 cellar: :any_skip_relocation, ventura:       "b60752bdc952a103dc312c9ea4f404f1e0b260e5914fde7d810f91a996f31db2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60ff659612cd002a25d1b9f2210e354d5608a6a8be6b39a1ee8eedaff24e037a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c70137bf656cf11da599cd653e60ad2976f1a5b00ee756ce9f6ec93766a3b27"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ericschmar/moribito/internal/version.Version=#{version}
      -X github.com/ericschmar/moribito/internal/version.Commit=#{tap.user}
      -X github.com/ericschmar/moribito/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/moribito"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moribito --version")

    assert_match "Configuration file created", shell_output("#{bin}/moribito --create-config")
  end
end
