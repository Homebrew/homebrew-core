class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.7.tar.gz"
  sha256 "631aad5327a04a32efb324df96bdc23c2bc84eff1f0816c8cf711678ed3b27e5"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f38a849a908a2a6b833d272a4972b9d15eeeeadb68430cc67202fd24d30dd6a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef6533c4357a3905bb08c5c89e795bca2447bb6585fb423b922799db3afa19d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfe92868ed63c6fbe198f0b52d1b2e67a48be3fb0af2ebe026410011a4181d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "abf56bacde8b6a9a463aea54412f01b4c93ad5c1197c98eb406be96eceda90e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48c4549a10804913ffa5024c0dd746adc4da41ef1a9b8dd7565ac9af0380cd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f00500a41204bd81f8ba4d99c93f9797cfaf39cc1a672d6a8171d90bb1979c59"
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
