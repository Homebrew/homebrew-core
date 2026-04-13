class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/1.2.1.tar.gz"
  sha256 "246c418cc73a9ae1026b94034ae7bb3b741f769b9df369bfb0b247b076749455"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8322b5687a499ae4bd72c11cab476d3ff1bc5cb69e7a25aaa7b4359d4f880281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2f4c9aa633d61622052c34cd246693d074969ebe15afc03fcbd66bcb2c787fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "393dc6b8f8c296698d4c824c1fd02b11a5a6d29f6d4e53edff56356f9c6f686d"
    sha256 cellar: :any_skip_relocation, sonoma:        "53293040e67fb079cc56ef9065fa9598c830a5d2a55d839b2c6b85453a9a3fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "decd897c5dfc86ac6968355a56538453b9503ca72fc7b5e8f8b900f8dd3c1c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c51dc2a3fde042d3699775744064db3e5ed1100edd480a83800062d650f104f1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
