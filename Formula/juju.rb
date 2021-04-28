class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.0",
      revision: "ac860f7db4296273ea2cf213115ec2c229d57a07"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "438907c9d66765eef9e400f8e5252d6a44c39f74f5f73f98f64f4a4839513bd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "9eddf36feed01acbe4cd7e725bbd15dbd81a629e51f63eb28221408f332964d2"
    sha256 cellar: :any_skip_relocation, catalina:      "dfe6da49391ca1eb23829c11595fd2cddca1e6cedd165148ff787d54be9ee254"
    sha256 cellar: :any_skip_relocation, mojave:        "88014080f41912063d16a635949d3a2fd8e59d22aadb5978f5210c4c8a64d698"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "./cmd/juju"
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "-o", bin/"juju-metadata",
                 "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
