class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "c6701a6c4665be5f1f1f5596fa5e6ace4cf75adde7e4e029e9e75c024fcfa6dd"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49f1205ab8b4df9e1f31af6ef1625458f0ae2d763be1b64da54fb0b783cf9c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b836294b3c4471ce4eee03ab7fff34f5431ba37e523a159ce854097524487728"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acf68bf49e2ab7e7c60dc612239a07c6df2e2152ef5a15c45cf8580deacc6432"
    sha256 cellar: :any_skip_relocation, sonoma:        "364ceb492e22e63bcdbdd9cf5149e5e3f7878ee02595903ca8de7979ebd8c1c0"
    sha256 cellar: :any_skip_relocation, ventura:       "4d22f7528ab22bf386c56079585f4ffdbc6596938dd74902e69336025127534b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5849cec57e6587634c72518ed4164bed7feb8801bc479a3f9cd4620ca0af00dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
