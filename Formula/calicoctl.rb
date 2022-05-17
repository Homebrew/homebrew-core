class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.23.1",
      revision: "967e2454314046f6568d1c571e8d97e000540f2d"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9a16b60d57314cf3203cb909735b37714e52d3662cd69a6efc71f0cc40494ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9e14f7d54ee47a0472e58ecfc8a4d6cca199d46e3be15f269247c43bf9a370a"
    sha256 cellar: :any_skip_relocation, monterey:       "7233da83a0357325c3019599940908e7952eee6f434b61499501a9be57cc54eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "18c18b2f625c6eefebf5f8ab3079603f6f87164ab45a4f01d80967839d1eedfe"
    sha256 cellar: :any_skip_relocation, catalina:       "cab5e94f4183860daff1666b49681e627ce8ad37ec9b94658063bf0fac4283eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b958e74358f2b9885875ee9c22296f57752d323c34693883f5a9da3f7f3a73"
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
