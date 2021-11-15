class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/dehydrated-io/dehydrated/archive/v0.7.0.tar.gz"
  sha256 "1c5f12c2e57e64b1762803f82f0f7e767a72e65a6ce68e4d1ec197e61b9dc4f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4f179282544d70d072f6ebea22527d7dfbb8a0d810d5965fc7266918fef4f6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4f179282544d70d072f6ebea22527d7dfbb8a0d810d5965fc7266918fef4f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "fb2330cd8c498ee40af3981951e324ef819b632b6c569c30f6ec6b5ae5c4ecd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2330cd8c498ee40af3981951e324ef819b632b6c569c30f6ec6b5ae5c4ecd4"
    sha256 cellar: :any_skip_relocation, catalina:       "fb2330cd8c498ee40af3981951e324ef819b632b6c569c30f6ec6b5ae5c4ecd4"
    sha256 cellar: :any_skip_relocation, mojave:         "fb2330cd8c498ee40af3981951e324ef819b632b6c569c30f6ec6b5ae5c4ecd4"
  end

  def install
    bin.install "dehydrated"
    man1.install "docs/man/dehydrated.1"
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
