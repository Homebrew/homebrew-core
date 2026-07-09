class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.12.tar.gz"
  sha256 "17ac67d184824c3f1fef6b0a7965cff7157bf57a5c25ed7d906fe800c74db0c6"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3efef079eb34e5b71436af9fd2edb2534e5949ffeb1c54b0ff054d5e9e5a135b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85a8d3830417852a0752b8d6f4dfa3123b492c8f69fb719e58edbb0cf3535744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f6433b965572f1d20364cd43302a56b301db44a4f237ffdf8c0b5c6ef1d7f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f33ab938d4120e4112145f72241c9aead0dc60529c5a8c901955fc35f66c8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955f09021628954a877c6e9d628d8d52f60621bafd4c9a97da127aa77a145149"
    sha256 cellar: :any,                 x86_64_linux:  "777eab9631665b987b9d8700f108d2148cdb0dab86ee2d367ba23946518d07d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: "-s -w"), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system bin/"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
