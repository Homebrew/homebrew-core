class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "02f6220660516b941dc4644eb7ae06a4717c7a8d193666f09a1725d53ab77c77"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d366362266526f44ed4955d4cb501b4cc45b013e7ee0fdf21ddc96bd5a188211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd35a4ef3986805df25bb6f4c97b93d1d4ded77e4d99ba2dc34ec1c6c83a7355"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d6a15721629057620dfe2182108f8e5b348b376739f878ee8ed59564eb22d0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "55a5473aedab637b01243a9ad5395f96e00b19d2d0d253af298e7b117e443f8f"
    sha256 cellar: :any_skip_relocation, ventura:       "3d737dc36f50252fbfd65571e0b229feb9c5e27578223ad6c7d078224bf3f3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6e6816226352f96417b8a16406af6e3be496d0d4fbcdb21d03d0c61a9ea475"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
