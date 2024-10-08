class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "7eaf61e0390184ce1b8a068805cea9776cbb7cbfc633bb01074274e36b768d1e"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f12faf8e7c3702f87a39ea53dd57eeb90aa5f3ca8110f10476a10f0900e6c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423435fe2f2eef76a293452c27597e45d750c0277cff43d7ead4a2275d71ae87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56668c2093ee80ae6f337b0a17865c42a69ce6707c792a8d39379c2ec8e9ae97"
    sha256 cellar: :any_skip_relocation, sonoma:        "8489f5a9898c163558cc5fa1b75d8565239bb198e28dbbf63c6cf351220d5604"
    sha256 cellar: :any_skip_relocation, ventura:       "00f8b2859b9304b6514a5744270af30b91b4938949a7ff59145401c741fd6a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a314d3416cbab4dd5135473993b272e847c2e58a431c90c9d552b5e41c110dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
