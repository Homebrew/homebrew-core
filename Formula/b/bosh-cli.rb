class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.5.tar.gz"
  sha256 "f893c11aae8705188c71e3d15bb2013f0c4ad50df84e6cf7f502ccca6095804a"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04ac207be9ba6cfb58b5d3fa90807a835df402edd3ea68a3a44c307183842f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ac207be9ba6cfb58b5d3fa90807a835df402edd3ea68a3a44c307183842f4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04ac207be9ba6cfb58b5d3fa90807a835df402edd3ea68a3a44c307183842f4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e1e8126475cf91f4ffa3edb6a8ec0d01b10cd0e5f7a38cdfd6136fb61101fb0"
    sha256 cellar: :any_skip_relocation, ventura:       "2e1e8126475cf91f4ffa3edb6a8ec0d01b10cd0e5f7a38cdfd6136fb61101fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adfe7c3bf209c2bf460a42534ee15f58694e1f5962b34370366264dd27d920d4"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
