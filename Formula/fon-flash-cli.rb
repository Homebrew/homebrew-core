class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://github.com/ericpaulbishop/gargoyle/archive/1.13.0.tar.gz"
  sha256 "8086c5c0725f520b659eecca5784a9f0f25eb8eac0deafc967f0264977b3fbe1"
  license "GPL-2.0-or-later"
  head "https://github.com/ericpaulbishop/gargoyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43f564bda23e787f38c0d22905b5d9064c16f2d74fdda6803c9b0c5ba93a6016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4ec6770ca7eb9d3e255cdf59a3c841aa6d903b9fffc1ee046569093d07728a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "143db70eebd874d6ade64f169af2009d644ea7efaefad070898a176d0de2d61d"
    sha256 cellar: :any_skip_relocation, ventura:        "5d62629e2ba51a6e7c6445614825f7b9a0cb7898acf0b4dd6648fc5ee7713501"
    sha256 cellar: :any_skip_relocation, monterey:       "7f937ecb116a3481b7d190c98f0e201b0c97b7d049e48218d0946f531b96fe63"
    sha256 cellar: :any_skip_relocation, big_sur:        "363a717f092ff03f306c3325544e0fedc51120b3e5b02db83efbbc0b8c36f6a4"
    sha256 cellar: :any_skip_relocation, catalina:       "c9ff936edefe6516cc80c50be0c4c067813e956025c394f654a0582a501795df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54cdacd60b20aeef73ab74ba77fe91170a2bdb62003416842c84822c5ab951e8"
  end

  uses_from_macos "libpcap"

  def install
    cd "fon-flash" do
      system "make", "fon-flash"
      bin.install "fon-flash"
    end
  end

  test do
    system "#{bin}/fon-flash"
  end
end
