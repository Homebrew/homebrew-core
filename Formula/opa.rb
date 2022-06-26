class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.41.0.tar.gz"
  sha256 "51771d3b0f5d84f6c35948b2253b499041719f683989cf72a596ff8ff23eebeb"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9dad7d7e997aefa9c3264ff8c50c18015266279ecf8518bfcccf23f1da6942f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c7c8f4bfb135f66017c65775aff4d6d1bf1cf8fd647c142ff835fd3dfbd8781"
    sha256 cellar: :any_skip_relocation, monterey:       "e73019ebb9221cdf0390b26434708f2613dbbaeaf834e2c13665d044ecc651cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b24328af430b28f9d689eeeb39b236987c528484923b0b692e820bfc44d318e"
    sha256 cellar: :any_skip_relocation, catalina:       "6c0a72ca8ddac0f4e5b9179c9be2ef818073dc156beb5f2110751fdd17abf6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7172bf3d0aedaee2d37cca92ae96be94328df0dd8d901fffa0405063271c0906"
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
