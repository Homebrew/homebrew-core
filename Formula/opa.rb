class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.32.0.tar.gz"
  sha256 "307b256e8361199cc941c65476aaf1f40e0ca83b23b1cc32583d8e93d5e2cf4c"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3fa8abc73bbe90449ab11e85dfab6bebb8696f79074c32b89cd53223f1956d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3153affcb524aa14ec1494dba07430efcd15eb6b181860e86387d50e9ac6a4d"
    sha256 cellar: :any_skip_relocation, catalina:      "dde8c8b427d9a115d0b3b99a582b2a31f7995601f23535ff3dafff923d97c2d4"
    sha256 cellar: :any_skip_relocation, mojave:        "3a914f6f99492d370cca17c24b57c57ee5c879a4daf55abdca5a645085f6f675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b64348154cd0b768e361e46bc55dabf71892fb83598d3effd833fd9d64fa1bc7"
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
