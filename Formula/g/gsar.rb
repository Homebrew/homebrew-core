class Gsar < Formula
  desc "General Search And Replace on files"
  homepage "https://tjaberg.com/"
  url "https://tjaberg.com/gsar151.zip"
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "dafb595928b7f06f2562e9dcd982cc3f4b30ed770eb6e34d56d1caf8745eda46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b42feea06c9d194323f2917165a2dd23e1100cd27e51194f379bbf3920c5d0ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dd43f9ab3392a433d2fccb9c9a45e75f76b5bcb2e68b57d5e6145630bcdff8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2259d416f5a0fa7f855879195ab6ff9855c0d9c4786522311abaa058e90fa798"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68051084dfbefccd95074b0e7cf9316fe916bd23e452a8c018b83c2aa185c0e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86de578de3d7754f9f3b6f3f092a262e32e2621f240105a8e983ce2b2afe4f7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "134cf018983cff2de6c78f4b8261891a23587de341183aa3ba78c410d565d771"
    sha256 cellar: :any_skip_relocation, ventura:        "101d468b37350873bfee957164379ee006a8f8947577d88c580e0ed4f2041197"
    sha256 cellar: :any_skip_relocation, monterey:       "7b479c3f3d2d9ab12bacd67ae0792472f803f1c59ea65b1c180bba9c9e8cdbeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bd2f9e7a24ec476fd8ae541dbeb60d1a5b93cc48790d28059d43fad27295581"
    sha256 cellar: :any_skip_relocation, catalina:       "6bba5adb80da7941b6a6a62015eae1ad8d6e27a11678a2d966ca0699ac05eae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "526b7939e186719e844042d86fb134a945e8e243ca556ec0e23045d2dd087b8c"
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
