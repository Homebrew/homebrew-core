class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "336873872c1eba9ce1a1c76a093cc552001f6c36e0bc63d4f823b08faa8a4d39"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6afca2e1669c84b50f2480986b4e406665a501bd498da95f32c29762c730cb80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1621475c56ef1d2439b3102927b6cb5a3b717882465d54e0a77f4b1ad0844b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d2d8419abecfa3c6672d1b1ea9cefdb9d6c926d56a50a64e46466607019c8bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d17f10010e0ce82c1d8d3f1529cb5bcc64ea697394e873cd75392f5be05a0a01"
    sha256 cellar: :any,                 x86_64_linux:      "deb0a934ea14bd47d92534ba59ed5905c8c45558a24e71019ad185ca393895dd"
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
