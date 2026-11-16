class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "de9a63dd35c0dd586a460cd1cd09f7b3463da330d781778f7694846f937da7e8"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1483ff5ae951b5bdd5890264b3a2c56bc0a32bde52e41be91afb189e0d9b4f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59f21c9ccc98d0bf23723dcd0da0713b0828219e144247260c03618c0c7a33f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd47b4b77f0f5b1c6f294d268bc2e9fd58649e9dac8e1071c0e61816a94716a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "565dcb5fc250a0279b033983965bbbf0d821e0fe386d1cb5711300895bb5ba6b"
    sha256 cellar: :any,                 x86_64_linux:      "b60ba9014e3014a9738454caa924833026ac536d10cbc2a3eead1adb2fdc0c74"
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
