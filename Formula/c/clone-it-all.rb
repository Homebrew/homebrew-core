class CloneItAll < Formula
  desc "Clone all repositories from a GitHub user or organization with a single command"
  homepage "https://github.com/MohammadxAli/clone-it-all"
  url "https://github.com/MohammadxAli/clone-it-all/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0ba566272eb6b24c4bc1c96f31e03a6864d4cea36da2090fb2bf6cf3deb33726"
  license "MIT"

  depends_on "gh"

  def install
    bin.install "clone-it-all.sh" => "clone-it-all"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/clone-it-all --help")
  end
end
