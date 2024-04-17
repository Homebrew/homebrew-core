class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "418980d5e509d564f1299658d9cec9f54a365d599b5ce5ada8bb52803c09d2e7"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f9aebc9365dde7a8a2e6482bb9bcec4fa32295dd4015fe120395beecdd7257f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c13e882f89533eee479617b0a90e2b0b7551aa2604efd887efb6cd8e431920a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c748d941a99d331eb6e2ed646408d58e7aac7a6e4caea9312e97ebc969d315b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bec61c1a80e8412d06c1d8994e2328e2e378ec5f33ef084f870080c7a9c19cef"
    sha256 cellar: :any_skip_relocation, ventura:        "c360fa057dd1f83d09ac4c48c04a84a20f26a4a1fef91bc1a2b3a0aab1646029"
    sha256 cellar: :any_skip_relocation, monterey:       "c29db183cd406aa09720ce0a59989ed11ef8196757544f3f3471d94dc1ed7f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ec609b9c78124d7ce0d1855c8fa903dc92bfed27c8ed1e603ea7e0a17a4530"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
