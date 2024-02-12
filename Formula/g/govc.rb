class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "70c4eaf4d0f4f756bfbc70c1b77b7693021c1d9b9fa4fdd367af047e0bc8230c"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcf7ab735bb8a4795f6b252ab3e791a60a4d97f4556dc6bd6ab69bc38a4a61f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "873b975f4269d64e8ce5d65426c16e57ba0476a6fa0707c7754a747234920add"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cad632c39a4d63a268fb6c4698f12525314555720b388a4a27d5168ce266e6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b98503422ca0b0e617f579b449421a6e2606f9f4350918e78f7fb0c0eb1f55cd"
    sha256 cellar: :any_skip_relocation, ventura:        "bb9b6b6ca414e6e8ab2aa7ab441abef8f405ae564283f89687d2e0d8167b970d"
    sha256 cellar: :any_skip_relocation, monterey:       "28c8f2348355c83219c726bddaa5a5f8e8d9b2a539b9fbf989f77bd52c729163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "020486d28a2be4747f62f908c0a4d8323c4cb9aea1ba80543816d5eeb2999253"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
