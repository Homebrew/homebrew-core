class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.28.2",
      revision: "9a96ee39f3833c3eabde151add8a84d546bcf24d"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a522634b7f526d29418ef18e47ee7bb9efc9afe622b5fd952460cacc04eda353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a522634b7f526d29418ef18e47ee7bb9efc9afe622b5fd952460cacc04eda353"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a522634b7f526d29418ef18e47ee7bb9efc9afe622b5fd952460cacc04eda353"
    sha256 cellar: :any_skip_relocation, sonoma:        "09fea37a6782009b3db111943d84ceedabf0acec830d241f94bb2ff6c410a3ca"
    sha256 cellar: :any_skip_relocation, ventura:       "09fea37a6782009b3db111943d84ceedabf0acec830d241f94bb2ff6c410a3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0941b2a1e540ee4a6a56831a01de3cc5e6583d1cf57c18af4bfd72adcc1e018a"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
