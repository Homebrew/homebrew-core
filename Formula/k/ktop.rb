class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "3ae063914b4ce5bab0a37d01a70b58424fe81866f15f0495d4db71091738166d"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    manifest_sha256 "faaa8062230c565461ee4be84d5ff5b58dd6a89a37a9abce8bc049472cadfe69"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80615cbe7697cac81cb228917a01103f5c06b4af06f0424a7174fbfce9d38333"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edad9e7375c4f15af23233cc13ac487321ed1d6e6013bd22475f1de72c7bf2ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4c2531144c993b7f032d1935eb667a326afe18eafe1a1af5173fb4a18806838"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "864d017a700f05998cb7008467c4e352002fd88744b8e2b9410fa89857ec56d6"
    sha256 cellar: :any,                 x86_64_linux:      "e1c88441b2417d5034259d7cb955d8fa0ee1fa8cbe0d6267d5b3011225bad061"
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
