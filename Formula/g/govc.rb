class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "8d6a2641db7c3096fd22cbe84f74439dd9bffae364acc61fbfd51ab143976ed2"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f11752238826f5cf4f817b22610fa11afe2a68d263ae41f4045c343cda452826"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fe6e104fa9e4105c4d90d6391dcd58ec67d5d7cae1a91c8db6ec3bae0d0de2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f057bf0468311ccc948bb19640165db8e2fb1ad9fbcaac6f4f31c94b874e7e85"
    sha256 cellar: :any_skip_relocation, sonoma:         "324e4f13d66abd50cea7f1ce66e5a3ce240b98d1313316e1730fc7588d5d77d2"
    sha256 cellar: :any_skip_relocation, ventura:        "1cead9e2e7e4beaae53127790f35e6aa0b54aa99eeaf91dd0a78f20ffbd35610"
    sha256 cellar: :any_skip_relocation, monterey:       "11c55e18ba456d4ce10cd3480208c1601fcbd757476566486a9d543a3673032c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6cdc751394a15d1b49a721913d5c7173744d8a785a7ec27ead05e845f3c4b88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
