class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/archive/refs/tags/lxd-6.10.1.tar.gz"
  sha256 "687495b7b989da5f29ab009f7e728462f845ebf65696d30c5a6a0d646ce3fb58"
  license "AGPL-3.0-only"
  compatibility_version 1
  head "https://github.com/canonical/lxd.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lxd-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1f2b1e6c6621e2c20f22cd3e87c4aa776e57fc80d83275d702b6785e8cfe9e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1f2b1e6c6621e2c20f22cd3e87c4aa776e57fc80d83275d702b6785e8cfe9e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1f2b1e6c6621e2c20f22cd3e87c4aa776e57fc80d83275d702b6785e8cfe9e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "93c7c4dbb6bd03ce7bc1ff97c5e1f7b603c2711c49fceaf41c73fc6fef350d73"
    sha256 cellar: :any,                 x86_64_linux:      "9e3e672cc1a855074267ed4c80ce2fcfedda3d38c621114201245c0316f90fc6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./lxc"

    generate_completions_from_executable(bin/"lxc", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
