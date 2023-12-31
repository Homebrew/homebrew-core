class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.25.tar.gz"
  sha256 "3a5fa5b19dd9dcd95573a68ba8bab685c19b0d7b78be022a9e926a8d68d368a8"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28515bd86ff2e6be68c3aa20f20c8d8f00b3050dd55cb13b56780c6d19324871"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97bc3551a105f467a1bf5b3c663fa496b94290619677a71b87b0b7c50782e16b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d113e641812c0e6179d4847cd8d07a79c59b06f2908a8414c37b0c70a18c3765"
    sha256 cellar: :any_skip_relocation, sonoma:         "b671384c0e9e73ead4c8bddb58544f08c4ff90ee686718cf7afceb08b15395d6"
    sha256 cellar: :any_skip_relocation, ventura:        "552dcae81b08d7c2c7feadedaa466efae7e67cf83d94f4c0c5a282e486ca44e6"
    sha256 cellar: :any_skip_relocation, monterey:       "da19f9e33b5c1f4647364f85667855014c9c7471e2e95f2e57a11903e7b57b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e42bd717337fd9ea95660c14aef6ee941224c397a64c8574d45754ba5eb3ac58"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}/gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
