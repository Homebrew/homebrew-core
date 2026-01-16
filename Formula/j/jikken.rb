class Jikken < Formula
  desc "Powerful, source control friendly REST API testing toolkit"
  homepage "https://jikken.io/"
  url "https://github.com/jikkenio/jikken/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "c1e8080c238d4aed349bf30a54ee8181661cb4cc846ad9bf16118ede5bd7939c"
  license "MIT"
  head "https://github.com/jikkenio/jikken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51dae7617f9a5b1df1c6d7c1a560b941765566919af5bb0a542d9140fedeea3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c2a6084031ab54a84caaa798e46fe8d1cf8ea7a50b8b8c141ceafed2944196d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dfcac83e5e02f29b3486e03c4c4128e02e6e09a1b6d85b26e5521e515a289ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf277333fd50c994440977d4302f217f7e607971071c06d0bec1a79cda240bae"
    sha256 cellar: :any_skip_relocation, sonoma:        "11bd0cf32af6ea9f71290b1d4b286558e6c1844039bcac9c47a717ee635e4d7a"
    sha256 cellar: :any_skip_relocation, ventura:       "bbc3a2c09c827fa77c5835d2c0fddde53e1f96f32ddfdc34325ee1b868fbc01f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0895649db77b4f15a4ef8486c389c85b3ef24a0299a9080f29a6e6627e68526a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21a00686c078cf599d5cdd70c453104551c618eb5390025ef30db5c24ad72ffc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/jk new test")
    assert_match "Successfully created test (`test.jkt`).", output
    assert_match "status: 200", (testpath/"test.jkt").read

    assert_match version.to_s, shell_output("#{bin}/jk --version")
  end
end
