class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/dehydrated-io/dehydrated/archive/v0.7.1.tar.gz"
  sha256 "3d993237af5abd4ee83100458867454ed119e41fac72b3d2bce9efc60d4dff32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4f179282544d70d072f6ebea22527d7dfbb8a0d810d5965fc7266918fef4f6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4f179282544d70d072f6ebea22527d7dfbb8a0d810d5965fc7266918fef4f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "fb2330cd8c498ee40af3981951e324ef819b632b6c569c30f6ec6b5ae5c4ecd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2330cd8c498ee40af3981951e324ef819b632b6c569c30f6ec6b5ae5c4ecd4"
    sha256 cellar: :any_skip_relocation, catalina:       "fb2330cd8c498ee40af3981951e324ef819b632b6c569c30f6ec6b5ae5c4ecd4"
    sha256 cellar: :any_skip_relocation, mojave:         "fb2330cd8c498ee40af3981951e324ef819b632b6c569c30f6ec6b5ae5c4ecd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4f179282544d70d072f6ebea22527d7dfbb8a0d810d5965fc7266918fef4f6d"
  end

  def install
    bin.install "dehydrated"
    man1.install "docs/man/dehydrated.1"
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
