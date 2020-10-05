class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
    tag:      "juju-2.8.4",
    revision: "58826716acc32c45e5aee043ca70541c72020ebf"
  license "AGPL-3.0"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3f021458406a0ea8c7f34db923c663022f3e149578675f16bd9272e5db745134" => :catalina
    sha256 "9e6b386d1a3955974caa25857de33f9228c7bb143c94313368b0329e6c11df0a" => :mojave
    sha256 "37ad8d6a457ffc097732fb69ac2166e36feacc156eae2ba4b5e5ccf5d4148052" => :high_sierra
  end

  depends_on "go" => :build

  def install
    git_commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{git_commit}
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
