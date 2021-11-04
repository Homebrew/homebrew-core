class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.34.1.tar.gz"
  sha256 "2c720732a0569122719fc653956b66f9af300a4d745bc4f56ee2c1c27a3d569b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ec9588f2ef21af1728b185a8153247ed3cf7601a0d4bdf9de1e6faebdf95565"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c33ea5a7b0805d904d6e9ef6685241c65fc8cd2a270e6eb8cf0a7dd7817203e"
    sha256 cellar: :any_skip_relocation, monterey:       "9a1b41bfc717b663aaf7a42582d55ca6d5a88e0e5757e3b49e52db08304df94e"
    sha256 cellar: :any_skip_relocation, big_sur:        "37f10c5123a63a75428cfa1f51fb562f2759fa8f524777cb05a013110c30e943"
    sha256 cellar: :any_skip_relocation, catalina:       "2fba8bde97d0b20df9dbc7c86428dbec96f7ab13fd0622624cae5b87c7bae054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad14d24cd671b0b58b9280789fa83a9db6532a160b492c0ad263f39c207cfc5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
