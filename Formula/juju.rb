class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.26",
      revision: "e7e941ad6e2c581fc4254417a944024fd2ad4aae"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "665d6c72dd4a89063d3cdad6865d008bb9f19413ecae27d72ec1635575389c4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e6568c4f9273229fef5e74410190f9857622408836a08c3c54db266ba6cff6a"
    sha256 cellar: :any_skip_relocation, monterey:       "c8dd6889318c1a3afad790e573dd52c3deb563f1394ef4a246b92e69a4ef4a82"
    sha256 cellar: :any_skip_relocation, big_sur:        "c51c3ce953894c9df15ca1184534ce05c5bbaf2573a17199619ed50684390cfd"
    sha256 cellar: :any_skip_relocation, catalina:       "daffe965073f8d520e0bea156b3130fd82b497063c7af3d2b7499d31a7aae111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de45341463dc143e0a9f03593693bb096ebfa2fe7fa97d453886887a8555dca8"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ld_flags), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: ld_flags), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
