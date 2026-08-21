class Dpic < Formula
  desc "Implementation of the GNU pic \"little language\""
  homepage "https://ece.uwaterloo.ca/~aplevich/dpic/"
  url "https://ece.uwaterloo.ca/~aplevich/dpic/dpic-2025.08.01.tar.gz"
  sha256 "0f38f5c1e91518826cb2c6e95624b390d1808efadc0402f83911512f0ce726c3"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=["']?dpic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "069e4b119b56fd45367c629fe3805950cc3b6cfeadee73e3cb7026dcb3de5406"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0bee67d515b1fc726a346a9fa48942b41c85c473ac759ca5d7aee0e850e889e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e51eb9b759ac15a295bdc87b54f3d8374b46b9d51145fbd35aef8ee189459fd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd6b43df0b91288003dff57d40408349cef599d179f862bd8371b7f6412006e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9471b7decb3914a6418112410f2345fbf298dda741dd3d5a0c9254b8d9694909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee392ae39ad1e121ea9f5a96b5fabbb157db774051e2fdd6c99eb2a5a9a3416"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    bin.install "dpic"
  end

  test do
    (testpath/"test.pic").write <<~EOS
      .PS
      down; box; arrow; ellipse; arrow; circle
      move down
      left; box; arrow; ellipse; arrow; circle
      [ right; box; arrow; circle; arrow down from last circle.s; ellipse ] \
        with .w at (last circle,1st ellipse)
      .PE
    EOS
    system bin/"dpic", "-g", "test.pic"
  end
end
