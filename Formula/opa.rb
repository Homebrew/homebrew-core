class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.36.0.tar.gz"
  sha256 "e597d588fba928767a949b1c6de69359e2174f2ec6a112ae957e1314ad0d76e4"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7de923996bd613cdf5359617c6da5dab5a41fa9c789947fb009e80a402dd27a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "803fa68eae566c69329b5586480151e84a771c599ba502e3b44f458be2dab156"
    sha256 cellar: :any_skip_relocation, monterey:       "55ef7d599a08d9412b56d623f4f0d0d8b78bddb20d533b35d4bbc4d0e7b1fc4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "935bcc3c6cfe0a7f76e1be0502c8ea9d6d5674cfa2f1489ef47d3f5705bd0321"
    sha256 cellar: :any_skip_relocation, catalina:       "7f43c96440361338c19947a0dcb195394810c10d3dc95767188f5fafb49da557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7a5e8ee850f39a5fae4b3aeb975d6d7ac17635bee34e1a4b768e734a8107047"
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
