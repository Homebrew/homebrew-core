class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "a8ce3cceeada77fead61bc0db551e1c4ba1a3fb51865cd075df39df307ff8abc"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e17654374554f8d3a4307422f36313d7f6cc323cf07b278af215303ae4f6289c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4825fa59f2f7706e6824939d61a0a7f29470d451e242d72e86c5beac37486bbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b6cfa1facef0eebc805770d87b955af813b3a522f01b1f96fc776a6ba21dd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f11993feae1d2bb105d62baca5356cc90fe943e430e567475cfa598ebe0dd4d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "574378dedc08077ef5f765002da32681f5cf66bb46f72ce856b415a14a5b0299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03aefe40f0362a13edf3417078d9846e524d451125c6640945f661148b7afceb"
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
