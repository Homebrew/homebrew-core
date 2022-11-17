class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.3/proteinortho-v6.1.3.tar.gz"
  sha256 "ee58364041b3449477c009ff607266303db85f5bc7959fea4c2a3bc4f0667e33"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "45dadf6468b8393016a56e6f4a7d96b716f2a28d3287997f2c46741a8f5d869e"
    sha256 cellar: :any,                 arm64_monterey: "6e2166fa31be4930405c55d44251068e1d0b588a1defa45758e3b5ea537ac660"
    sha256 cellar: :any,                 arm64_big_sur:  "df9bc4db6981f832a97522798967b9378941be3552e860dd95f138978d07a850"
    sha256 cellar: :any,                 monterey:       "85e66388fdcac988b05081d9db0958470f6fafab2d59afdebe3392f2486735f4"
    sha256 cellar: :any,                 big_sur:        "59e9c753bb011a865cded162de83161ba078cc048ca307b66500e11be5846a14"
    sha256 cellar: :any,                 catalina:       "17c3edffb9107e5470a0cb7fb0aa1a37baa7e14bcd7a30503c3cd8fb63175e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df00f9cfac34186532a0e2e2113d07a160830c76fa17695ce70dffbe48818cb2"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
