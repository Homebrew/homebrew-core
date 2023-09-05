class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.30.7.tar.gz"
  sha256 "ec5fbe10272ec30bb60ffb54803354f7d12c6f1062bd13615018f15eb2bdd8df"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "207b62d9dcd9c8309df760e4e73104d3849112f4d91864c22f85df35891856ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c81b546673b4b7d0527eaa2e7046547ede22e010a717c366f54d90c45e78ecc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58be12cf923c6b555cd27bd7bb2de661a043302174902dff1c9c8ff399c77d98"
    sha256 cellar: :any_skip_relocation, ventura:        "a67b7ec294f5a444166219d1b11176a5c248128e9349c1788acb08ccedecfa77"
    sha256 cellar: :any_skip_relocation, monterey:       "228a70d7ad9e26299653a540d042ceb612fd0dd4006ce6d50eb3815e3001a811"
    sha256 cellar: :any_skip_relocation, big_sur:        "40af296639f2b1b0794ed463686fa4e2f1d408bcef48aa6ee3a72073fe8621c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a7eb8b8261ae455d64166a62d151ea8cd66306f8d52059ffe2dbee03007c3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
