class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.14",
      revision: "ca9e03c060c127fa98ba1730604dce0b5417fff6"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8abd55ea892fdbbf2c993f82407c0022bec530ba0ddefa3b683e26496e5f88c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "f12cfb7ee323ea3278ceaac66fa71cd6156a960d3f622f34093d88e511934e95"
    sha256 cellar: :any_skip_relocation, catalina:      "c5a333be3c637f98c0a77a335959adab5f75dddfafbc6158ca9f7281586cb716"
    sha256 cellar: :any_skip_relocation, mojave:        "c9fe667fcfac56a67ebbadf58da8892de11884278f33464a8338d01925565e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ed921c528f6c87198efba3c802d5217e6f658585812becc8329239bd2ac9df9"
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
