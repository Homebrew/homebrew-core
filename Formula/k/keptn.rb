class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/refs/tags/1.4.2.tar.gz"
  sha256 "0b4489256597d5cc0963e387a750f183d389bdda93ecd783e674d702c6c425ed"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0f40ee4af457f38467a66ec8eb6e720842bca5ca75f08d2eaa84075e7d6d374"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d5d5bba0fe227aeaab85159dfab03c7f438880a4b12d8fcf475c04ee1231cd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7028fd1d9edd6eb21745ad4f8394130aa09c2b56789d3ec3d25f0af8e2e4504c"
    sha256 cellar: :any_skip_relocation, ventura:        "fe2272970e14cded9b79c9ee90f009b23d9b3dd2564e1d81e27225094512ab65"
    sha256 cellar: :any_skip_relocation, monterey:       "5391066339f23d10a89653f7b3b6e8a05c551f93ed52539fbd883e5024afcad4"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc8777eff2b3d99da12833b7442670afc076a5edc24f30fe69b26c0753314224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8658de205632c8446f98b63597122f3fe10f6f71b37b8b06029c11a267802069"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/keptn/keptn/cli/cmd.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ]

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    output = shell_output(bin/"keptn status 2>&1", 1)
    if OS.mac?
      assert_match "Error: credentials not found in native keychain", output
    else
      assert_match ".keptn/.keptn____keptn: no such file or directory", output
    end
  end
end
