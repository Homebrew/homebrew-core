class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.7",
      revision: "95b319ca0ac1098407a50c7552f1309cbd28bd21"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3285ef33f37f70ad3f8f9f7191e144eebdf3c50ea6780b41ba856d506f84b9c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "21647fb5ac56df194ca34801d303811fcab7e48febee613a95e86775f06a4ed0"
    sha256 cellar: :any_skip_relocation, catalina:      "0dfb4de7fc247ae09e0f80c7818ba6b6d5376ffc849e1ff4b8815c7943af3f94"
    sha256 cellar: :any_skip_relocation, mojave:        "22464ef3006925ad094e955a70d6dcb0006d72f71a5cabf7427bffa03be139ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2cef8aff248b31b800fa111ae1a45eb3ca7c18203f2c0d2ccf145894eaf51bd"
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
