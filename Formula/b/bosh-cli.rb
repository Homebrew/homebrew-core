class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.7.tar.gz"
  sha256 "184d8166aa8bda7fc3b12a35e7e4432e1043d10340f78229a8a4eaf3e55fe7a7"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "199a2b88e9d6132d528ba6a99b61e6fb73817d49ad396229f799f4c7f8fa1374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "199a2b88e9d6132d528ba6a99b61e6fb73817d49ad396229f799f4c7f8fa1374"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "199a2b88e9d6132d528ba6a99b61e6fb73817d49ad396229f799f4c7f8fa1374"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b6b38a9c6587d1608fe98d72f83f07c026a46b7e283fbe74c0777f525cc8e99"
    sha256 cellar: :any_skip_relocation, ventura:       "8b6b38a9c6587d1608fe98d72f83f07c026a46b7e283fbe74c0777f525cc8e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "286f6ffc88c79d25dbbb4bc10a68c3269240a5e9d8adf64d5706404c7098668c"
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
