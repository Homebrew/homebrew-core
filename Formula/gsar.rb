class Gsar < Formula
  desc "General Search And Replace on files"
  homepage "http://tjaberg.com/"
  url "http://tjaberg.com/gsar151.zip"
  version "1.51"
  sha256 "72908ae302d2293de5218fd4da0b98afa2ce8890a622e709360576e93f5e8cc8"
  license "GPL-2.0-only"

  # gsar archive file names don't include a version string with dots (e.g., 123
  # instead of 1.23), so we identify versions from the text of the "Changes"
  # section.
  livecheck do
    url :homepage
    regex(/gsar v?(\d+(?:\.\d+)+) released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68051084dfbefccd95074b0e7cf9316fe916bd23e452a8c018b83c2aa185c0e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86de578de3d7754f9f3b6f3f092a262e32e2621f240105a8e983ce2b2afe4f7c"
    sha256 cellar: :any_skip_relocation, monterey:       "7b479c3f3d2d9ab12bacd67ae0792472f803f1c59ea65b1c180bba9c9e8cdbeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bd2f9e7a24ec476fd8ae541dbeb60d1a5b93cc48790d28059d43fad27295581"
    sha256 cellar: :any_skip_relocation, catalina:       "6bba5adb80da7941b6a6a62015eae1ad8d6e27a11678a2d966ca0699ac05eae2"
    sha256 cellar: :any_skip_relocation, mojave:         "c3bf2fcc08cefb75fb0c8cae257f0b70f85172093649e065860324db6338f43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "160d27dd1c5497302c7249adb93a43cdb81669cdf5d01a23405adf42d5af16f4"
  end

  def install
    system "make"
    bin.install "gsar"
  end

  test do
    assert_match "1 occurrence changed",
      shell_output("#{bin}/gsar -sCourier -rMonaco #{test_fixtures("test.ps")} new.ps")
  end
end
