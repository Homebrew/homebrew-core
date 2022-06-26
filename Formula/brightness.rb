class Brightness < Formula
  desc "Change macOS display brightness from the command-line"
  homepage "https://github.com/nriley/brightness"
  url "https://github.com/nriley/brightness/archive/1.2.tar.gz"
  sha256 "6094c9f0d136f4afaa823d299f5ea6100061c1cec7730bf45c155fd98761f86b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baf05ff80ff28745c1fed3f18467752c217236335d14d99d45fa6330a010a7bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "553772d87cb89c4f482c3b4ea48eeb404a7572b6277ced0d87625695e480b4e7"
    sha256 cellar: :any_skip_relocation, monterey:       "b8eb62151ad68eaec24fedcd6e4f7a7f97970f044736cec19818c88d8ba9afca"
    sha256 cellar: :any_skip_relocation, big_sur:        "687b60a636da1664c3c16ef69e84556cfe78d04e3e080de1ca0182847df2afc1"
    sha256 cellar: :any_skip_relocation, catalina:       "d9a033e343696c88863a7d231197d27be9611a2c8c56c83b4fd2747e2a2e5a7e"
    sha256 cellar: :any_skip_relocation, mojave:         "de0ebf57bf951ab4e90a8bb90eeb0ec659a696a7c2f10a5c32d269cceee44dce"
    sha256 cellar: :any_skip_relocation, high_sierra:    "08b29843308b1cd3603aba3f2e5e3d2e7dec34dbe62bdb5e506b7bacdcff8df5"
    sha256 cellar: :any_skip_relocation, sierra:         "edd4123953a961e94ce78b076b116c987f668ca73e0a67339e908ead6ded8441"
    sha256 cellar: :any_skip_relocation, el_capitan:     "675d9a1b7e39b75d2b569fa4f148fbc2342dbcd4a1b23045763c0103058ecc26"
    sha256 cellar: :any_skip_relocation, yosemite:       "360b009d1a2ffed665c9d9168b3f91edba44c8da8f08d2f307b09ee63f399e0d"
  end

  depends_on :macos

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/brightness", "-l"
  end
end
