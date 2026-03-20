class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "d942c4695c1312c15109db8f14a0677c972d2ab78e28efdc2b8827dbe1306672"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86714a4cba5f1b14e6208d337b944bae39cfb8c2653d16f6aaf151b9af9d2938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86714a4cba5f1b14e6208d337b944bae39cfb8c2653d16f6aaf151b9af9d2938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86714a4cba5f1b14e6208d337b944bae39cfb8c2653d16f6aaf151b9af9d2938"
    sha256 cellar: :any_skip_relocation, sonoma:        "3af464afaba71a28d9916eb7a940f6e3fcd8556c42f94497b075bd1ab216395d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e979005260d7a33cb8eeed014ab78956357a284cd0bb9b7ee15e0b4cea46656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92cfe0d1ba6ae5b18ae2df91270ad894f18e8316f83c50f1c22e3872d535bacc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
