class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "244fcda930606bc4e22275c3144772234e533325f19db6ada1623b2d4e3dbc95"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    manifest_sha256 "2329ed5ac2512564bbb962e8f43003c329b2e2313ebb9f6d4a72ae17e732d15a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5d914ba55d316ca42dda14a9cda34cb7d355285f068b2f56e9924d647fccc5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca11ccfad3b9ea2c8ac8d2af4b8bdacbee63ef42fe4af097f44c850239e69615"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02906b53d93cc1fbf5b5bdfcd785295b08c87b2940eca0aef17e1bebbbad26ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a77bd2da938d6082477f03af853de99b78ac136246366c083718955fd32a20e"
    sha256 cellar: :any,                 x86_64_linux:      "ba1b15be2dccc1a99ef6311f9b8495a905e8e91f9e4f90b3f0aaf50f57451e23"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 3)
    assert_match "connection refused", output
  end
end
