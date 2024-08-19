class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "da1a5325492e842ced3f76d93c76238038c6524280fe729855c592b0e8e04f5c"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e50e279162d5a4bf013f76ef4d0ea8743bf206dcd931aaf8be8174be49360d21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b64df50e2fcfbc00025bd2bc925b6913d7aaa5090f8b63842a6f1b153aec69b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c1f799217d2ae27fc1ad78f356adb0326a76f5e00cdb09e112e4598c070eeb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb4d813e37d61a9493451fd41f2197732619f48935bb7f2939da80a542865a38"
    sha256 cellar: :any_skip_relocation, ventura:        "682b773779ce75e69b9bf9e9538e7cea6a78383efedff5089ab636be16ec4791"
    sha256 cellar: :any_skip_relocation, monterey:       "329402945468d12167c28071ec7b625b8953fa2810948620c3e73527b24c8ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6cbe780edaab7c09fe789b6c5007af25173164f02e4167eed1ab736b2ffd73b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
