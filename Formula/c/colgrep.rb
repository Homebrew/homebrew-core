class Colgrep < Formula
  desc "Semantic code search powered by late-interaction models"
  homepage "https://github.com/lightonai/next-plaid"
  url "https://github.com/lightonai/next-plaid/archive/refs/tags/1.0.7.tar.gz"
  sha256 "5a5449ac01b9d2e7301d02c7f74097d1f38a90265a4106113429328aa35bb21d"
  license "Apache-2.0"
  head "https://github.com/lightonai/next-plaid.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    features = []
    if OS.mac?
      features << "accelerate"
      features << "coreml" if Hardware::CPU.arm?
    end

    args = std_cargo_args(path: "colgrep")
    if features.any?
      system "cargo", "install", "--features", features.join(","), *args
    else
      system "cargo", "install", *args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colgrep --version")
  end
end
