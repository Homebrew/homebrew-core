class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.8.tar.gz"
  sha256 "85bbc60cff915e7bf7f9c8b3400aba7cc3ae32928584a8b13f9d1ed2556245d4"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b98f71156df430c59a0da58e51b9a40cde533166b4f4a7c7afcdbc735472f09c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "300994286238b22cfd825692fb662b0d249d9b40236226c48ba9aa3cf6a24940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49821a51423165733e1acd75b6454a315bb77f87a8f7229fd9943dc6ece5047c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eade82a4d18420e02a625a9273f26c2861d650b4c67cdfd68e73f3cf2425b68a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8159b8fdcc148ab15a562c1aeafc07dce3fed614f2308ccae4adee49e0fb6786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03d249ca7efea092970b99483739c69b798f4c3d9e4c153fa1b8f9a8ab10072"
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
