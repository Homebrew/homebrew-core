class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.36.tar.gz"
  sha256 "208de2a724fbcdbc7d2b8ec38d8d61451fe8967bab5329ca4400c323378e53da"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "788215a00f75fbd58076477c4a91320eb1b4d14ef0b37ef96acde3095bd9b8c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a586b48db5db9882f72c7f1caf3a8ca2de1322dceca8e71feffbbc5575ea3a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a586b48db5db9882f72c7f1caf3a8ca2de1322dceca8e71feffbbc5575ea3a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a586b48db5db9882f72c7f1caf3a8ca2de1322dceca8e71feffbbc5575ea3a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4ff2529eba3c787d535ab0634457f99d0108f6aaf1172f76f615c1e9296d4bc"
    sha256 cellar: :any_skip_relocation, ventura:        "d4ff2529eba3c787d535ab0634457f99d0108f6aaf1172f76f615c1e9296d4bc"
    sha256 cellar: :any_skip_relocation, monterey:       "d4ff2529eba3c787d535ab0634457f99d0108f6aaf1172f76f615c1e9296d4bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a521153a7c5fcb8fc0e1f5ad26e9a445e849b133f8200e47be007c5b96caf022"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
