class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.44.tar.gz"
  sha256 "07aeec9ea820595fd6beba7bdf76cd746988b0d64ae84275ab2b61edc7eedf6f"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55376e634d07e7373fd4f77822537cfa25e46676bf6e81b2c0a10e72ff9c173e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56f6bc182eb495b4e9fae7d53d3fed03f1b31dbdbb057beba472557b994baa1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75f4fb204fc72cfa8799977a3eb584f0d0acced40145120ad84ec5420224d102"
    sha256 cellar: :any_skip_relocation, sonoma:        "14783329f9822943c2bec7422aed72eec4423566c3690c368150b5fb04775fad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faa480161224d2c65641451e5358adaafea739f6e1684f7e19a65d452a50b31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3361a6bfa882bf1a94de357e37e9c96cab87b82527f2903bd93270684449d33"
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
