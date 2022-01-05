class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.36.0.tar.gz"
  sha256 "e597d588fba928767a949b1c6de69359e2174f2ec6a112ae957e1314ad0d76e4"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c3092148817fda33c83ec4883a2a122815b4c88c9df477810fd63923d6ab83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35021039cb582b8fac8599c6c04a85545010c2010fd2ba7524730850dd832a5e"
    sha256 cellar: :any_skip_relocation, monterey:       "4d9764794d6538e838d9aa346b4124aee52159f9ef84718ae0e837f31f26152a"
    sha256 cellar: :any_skip_relocation, big_sur:        "269ef40eddb52342086bb5bb86987bcce33d970bd2019232bb2c3cc6e6041603"
    sha256 cellar: :any_skip_relocation, catalina:       "b92cd21190ba202ed171c570321c13b8579ba8bfbe08a0591e569a880eacdb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7275a5d1eef3cc17b509d939bc801b3efdbe59300e2bbb6faeb273cadf77bae5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    bash_output = Utils.safe_popen_read(bin/"opa", "completion", "bash")
    (bash_completion/"opa").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"opa", "completion", "zsh")
    (zsh_completion/"_opa").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"opa", "completion", "fish")
    (fish_completion/"opa.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
