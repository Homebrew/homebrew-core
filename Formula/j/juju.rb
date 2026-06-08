class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.11.tar.gz"
  sha256 "6c9af1b3a7e03de3e6d6e5cd7a6ecc477b08d4f7ad1bfc7de3305098481ec40b"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f90886e1b11f3187c6b8fc2f5c128a8ffa21d054a4fd05a8f6511afccc3a76c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ce0878ca9269864890fa6780a6de1edff83efeb6d8683ec0dc31c707cc7c15e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a227d812fe819e2a25900c54c1e89b215068287733fb49381fb442380b11a235"
    sha256 cellar: :any_skip_relocation, sonoma:        "a09c825206775c0c611fd2248c65acf210553bb701c51f1cf2b849a0d11c44e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b658897379da825abb91a5dc999b1c09326a6bae6e6762a0a0bb98867f1c730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ab89a0cc9c808714b7bc479d42b524f08e247cd4ac0c7e9db6dce85f7ea403a"
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
