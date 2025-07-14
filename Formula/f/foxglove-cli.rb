class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.23.tar.gz"
  sha256 "d03e708033cf7665ddec02625fc97380dbbb06177807f3c8b4d27f6a696bb348"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f868121298b783e4e1927a784877025ba11502f91f49914959b1f07b6851a66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb87cd65e811de27dfcbb9ace613a8f604b808fa78524dd6739b058b8b610b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e424bc77713cf56c62d2b92593305450f5054e09c6b550cd6e4bb216ef9ecf41"
    sha256 cellar: :any_skip_relocation, sonoma:        "82d81528a09e5e8a1afbf7be0f138b08d76faf8551055a0fb4dea833afd9b836"
    sha256 cellar: :any_skip_relocation, ventura:       "9c46958968f102fa996048c85a8e5d575f58a545bcc932ff49f7dcf71744c681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eda7e6f62d7a7fc87d9cb7e3d6aca29a7c2c94eb9009d7e84c30c022759f208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5dac5a6cf8e65d148242235fb04cd40624a43fde0fd060876a08e332fc30707"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
