class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.30.0",
      revision: "572a32dd9b2f9784d66d74712d5ec2e703d25083"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "684dc23bb8f8a9ee58242484b430d590653d3d82af0d438a94ebf00b1932da1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684dc23bb8f8a9ee58242484b430d590653d3d82af0d438a94ebf00b1932da1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "684dc23bb8f8a9ee58242484b430d590653d3d82af0d438a94ebf00b1932da1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ebe618e09a0bb695d5bc21dd446e04f27eca70ec93130dd5b059fe8cca8c229"
    sha256 cellar: :any_skip_relocation, ventura:       "0ebe618e09a0bb695d5bc21dd446e04f27eca70ec93130dd5b059fe8cca8c229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a605d4efe02cf53f67fb8197ae57e84fdfce07d664e262fb6e7c444d5bf4bbb0"
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
