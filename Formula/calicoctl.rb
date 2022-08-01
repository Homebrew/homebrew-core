class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.23.3",
      revision: "3a3559be17f44bd5b52134c7052788ae61aedfa7"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f00848cd05c585284f3e1faf5456393eb817c7abdbf2ac94942ae1ba3385097e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "473fa1cbcca98f46ebffe043396b78e5ba5642c09528521fe5ae713029ac7a9d"
    sha256 cellar: :any_skip_relocation, monterey:       "44d3e9a2d2b10a372bc17f409527d31703b705b950628d94c4930bf0643dc4ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "8034bc6c0d96903d7e5e35a7546ce922a972f3dab7f02cf973f343068643f20e"
    sha256 cellar: :any_skip_relocation, catalina:       "760bcbd613dc1e838dcabfdf295a5fd35edc54d0b90a57686ca329d7d9ea9e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b7cba189827a69b24ba9f34fae42641379cd357f24b05461a5718f56367054"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
