class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.20.0",
      revision: "530dbbe57009f4596bfeedba1c8169becd98b9a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b04d0a5eaa653ef34956c168d0fad4562174acc31c09d36f6e6d4eed7cd992df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee93dffc4e62938114a1698bb14684a23be9e6eb49abc46edd4d4a9b3b295bff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "555bed3f6ce4b4792ee15df33b81dd6e697947762cf457fee0382704ba217638"
    sha256 cellar: :any_skip_relocation, ventura:        "9fc5382be0fc70f73a57c5cd80a90eb7ab2bdcb8ac98eddac79b1d20db22b3fa"
    sha256 cellar: :any_skip_relocation, monterey:       "473af0b5032345c832fdf5695b3b336df570c830a18495fbadd9352cc151e880"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f964198fd65392cb8e7dc188b7396fae3799e52cecd51e33cdeec2d39a488c5"
    sha256 cellar: :any_skip_relocation, catalina:       "6694687a83965701435bb6d833d869f238a2c3b6958eddade66e42c88673d15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f2cde2adc48669a2b381cdb172f363cf3da7218513d569f0b184ce8b4ad381e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
