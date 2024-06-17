class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.37.3.tar.gz"
  sha256 "f44abe8820a9be0647ea55811b7d87321dcf586a7065dff643f2992119525ae1"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e914b014164347143e11e39745baf20a6144f7f5b008dc4464c1f7ba75f45dfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93b9dc8f69cae6f494f5263d9458ab35c80beb412d2b7fc37487aaa0913c3a2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1172eab5a3118f616831806ca015a6ae48ea365cee024a4608a3da41fc039cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "58876927af37653c49123a3696f7f27048434a8bad13d933387ec77f27bf4497"
    sha256 cellar: :any_skip_relocation, ventura:        "14b93bbb046d0674b7e4ef07c85b2be19cd9f6d93fe5d371b7414b441eb8bcb7"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd507a255b58c4d30ac6d4861d9b0b83547a969869005f3b30ba29c3e1b0b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "977a81c52547c6371aa62b986b69759d14c9960cc835ff8fabfa541fb8d55d61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
