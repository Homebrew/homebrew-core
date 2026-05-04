class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.42.tar.gz"
  sha256 "05adc486f5f6a72b173ef1921608a9458d560e422010b78c780703943afd8ebc"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aa055e32b2d0ee9bcc0503b7c008c08e2f1fcf612f501e56796a5ef829f013e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c15479c539d89fc11fbe4859ad7d72a738730ff0da96a154f569fa407f5811a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17c83d87818d107a2904048be0b9b3d88dd8b325baaaea59077631efb583fa53"
    sha256 cellar: :any_skip_relocation, sonoma:        "147fe7822bceec4dd3957568c0a97fa2eb6c9d18c996e148f1aa0adf11625306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "851605835cd6ccb7f26de0e34e6e74b1a6bf118db644f00147d36ec4c8c18bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17a509ae55ae5d72005e9bf76e3a9d0cf55d6a8e82c731bc02ad772e0a46b2d9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"conf.yml").write <<~YAML
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    YAML

    output = shell_output("#{bin}/gickup --dryrun 2>&1", 1)
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
