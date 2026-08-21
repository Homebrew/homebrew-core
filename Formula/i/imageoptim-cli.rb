class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/refs/tags/4.0.0.tar.gz"
  sha256 "29a6d28984273eb70ab8be03ea028a5b7285b051d442598e41bd77306ead8f52"
  license "MIT"
  head "https://github.com/JamieMason/ImageOptim-CLI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb5fb98b627ae88aaf96b90cd193a38133aabed5cfc6503d8d6c08173409d74e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e1b1b87bd92dcad96e4ba644348043dcc496303d8a6dca08b3939764047b2f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ccf08117ca78614c871ca5cf6cf1814d0de722e0c37075afa535ae6665e8931"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aad376b57cd1173637b7660b04cee740c6cd07e956b2608ad7e39e1191474f8"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imageoptim -V")

    cp test_fixtures("test.png"), testpath/"test.png"
    assert_match "test.png", shell_output("#{bin}/imageoptim --dry-run --no-color test.png")
  end
end
