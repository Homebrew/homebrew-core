class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.16.tar.gz"
  sha256 "d01fdd2778628b99d6c920d523efdfb6271a98e9ff32311fd953bcd59b901691"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ae6f03d11bff0adea61a37a092f405c3dfa48af05216efd418881edf2931b53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5d766c7697c7cd664652eaad08730746700d7cecac030e791c896a58c5105a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84b23fb82243756e3da22620f05267f756dc7265382116f6bd18af4370fe2c36"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ee40e84630ecb98f7ae6f13fbed7c9df6561ea80ad2a0c24997b5a92eb0b7f3"
    sha256 cellar: :any,                 x86_64_linux:      "8790befcc7228ecbfc67010043fc15d0ad227cf15f54a9b87a365901b99baa96"
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
