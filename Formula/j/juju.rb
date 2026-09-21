class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.15.tar.gz"
  sha256 "7543bec5efc8e83ed49e4fb84177df46c67109ebc4f38b26b84c72d5e83d2348"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6cf3602643e7fae794aaa2e08aea8daf92c3404179d0e0e11dacefc616c7e1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ed5a384af99c344d57e5fa502c102f076905058ddaa7f146c236be28ca3f523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8c843d57e981c89d145faf15fd6cdb61bb8be96a282a74cf35c853730646e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aba1848d7d16dcdf1fe051c16a70e1c9826fe6fbd2b4d0638ce71c40687dd76d"
    sha256 cellar: :any,                 x86_64_linux:      "820e4e6c7c449c141c13dd3d507efe764cd16829b5e60d9e9eca9cba48205011"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata"), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system bin/"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
