class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.32.0.tar.gz"
  sha256 "06c6a51a92fcd37809ad94535dd3275ed6f57cf40cd8fc5a4953a3de94dff98e"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d876fb28b983c0424e9fc098fc7fceb28b6e33c17d3ed55738da225f627605c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f86f1c27f1f93420c0bd826b54cdbab70effa79af47acc2155de5e3bf2b80bd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45d4144b84261796797da3c5bdc70dba400cfb6cb4e5d9261d10700c1b2a0d81"
    sha256 cellar: :any_skip_relocation, sonoma:         "73536a5bbf0e051f92b3737b1c35831a6e134c1e98fe39eaaaa99c264694def3"
    sha256 cellar: :any_skip_relocation, ventura:        "c4bf8168a2a2f00a3b1e45dc4766de146583684e68239b760771a41434ebb61a"
    sha256 cellar: :any_skip_relocation, monterey:       "8e708412f7ba86849964c9b7437bf9391df23289ceafe6ffdac5ae2b05afacf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66069eda96ba12ffd2af41eb5f453793874306f9e6c31015c541ed93b6546f5e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
