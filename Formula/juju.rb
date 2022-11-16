class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-3.0.2",
      revision: "8bf53dc35b25145ef39051fe4136135a3dd53d5d"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efdc3898a5b22a0f925391a07af442c9de1cfffa94bc82723ac8d435da419750"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d439476a8746b7a7b486b0ef46a07fa2eefbdff33e4e2c855d1381f93cd3436c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26dace36587ca075e0113980806e526fc356980aa0c470f74b817857e031d3a1"
    sha256 cellar: :any_skip_relocation, monterey:       "822fa95b94de5c9de8510ad41cbc8b8a2ae95e295708f1e9a48dc9a03c5f7a05"
    sha256 cellar: :any_skip_relocation, big_sur:        "405e460986bf3c61a5151de19a2b6c3a9c186237722ed7e58ad36bf36a230f81"
    sha256 cellar: :any_skip_relocation, catalina:       "b59d81f674ee2184f9a92d5393b4d3995cdf06bfb4143c012f93c23a5f8eedc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e205731ee1f930616350ab4710c13b88d7c5569de5855585c308572b67406c"
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
