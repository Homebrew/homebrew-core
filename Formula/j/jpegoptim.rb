class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "90a309d1c092de358bb411d702281ac3039b489d03adb0bc3c4ef04cf0067d38"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpegoptim.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6f2da3ecfcd521abededbff7aa2d8578773ef9951e9ad2b859fd5cdc05470102"
    sha256 cellar: :any,                 arm64_sonoma:   "ca3a05d563b803911fcec6940ee9a26bd6e7bb21519e5841947635c856e1bc50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebded7c6ca4bc0d67213156202bf36cecf058ed16552c085f6b48dd57a334fd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b388ed2fb35def26b59849050da22ba28c31a94f6a820ea39d396e322c9d70a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45382d1e4a3a561835928eb98d0d6de7dcc8318845ecd34f8ff539b9581703c9"
    sha256 cellar: :any,                 sonoma:         "8e12fb740776885920bf38fd79497df975e3dc2e062c5b8f59f2cace99ea1812"
    sha256 cellar: :any_skip_relocation, ventura:        "86fb1ec394a43558d382fbc2544050d361e9586dd5dacdf4257a20c1f9244e34"
    sha256 cellar: :any_skip_relocation, monterey:       "aa1622b89c22a2d162c211d818828fa0ef1577e9235f936d36643c8ff02f9494"
    sha256 cellar: :any_skip_relocation, big_sur:        "99529c2dccf16f25d1b31ca8a9d20e638c75a8a13af5875b30fc4174a757c7f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0547e662487a78c35cbb4e864224380730a6793cad67414959572cd7c30f08cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e35ae062ab96e9a8bd73a41cdfc896d2366db52f2ed2eb9a67a7a99167f49a2"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
