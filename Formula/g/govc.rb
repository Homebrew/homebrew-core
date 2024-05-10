class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "f92bfa326e523fbeca438146ea7c06ee0e25870858d001dd1750182d4af7aab7"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "005cccdd9560447253a1e01c21907520253f9420c5f448c39986c3cdb5884495"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac4e24c99151e2ef72c0a24244644cbae3cc7637899f62279d07af62998ad935"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c439e9b8124a5ff1c0acf22d34c3c0a38fe7f7c72cfb91a1957030f62fb6bcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d64fac381c243a1598c5f273ba182fb58c44c190630405b1b66c2d208868f15"
    sha256 cellar: :any_skip_relocation, ventura:        "2a5a15b5d7e031c2f885fefbe9838784160feb40303696e00b434b5d8bfd1b9b"
    sha256 cellar: :any_skip_relocation, monterey:       "fd3b5492814dfa0a4bedfc3a996e067cd760de30ffbaa2f9264717e1c82ea6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4349ef4563b8098080309682ff1e4e46a95f77b05b098314071d793f71413ac4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
