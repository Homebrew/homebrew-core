class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.37.1.tar.gz"
  sha256 "cc392b43d9bfc58f2dcd470086e90ad709ce1678a1587b588f4f5a6b49a23aab"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7fe9ce6f21aabd0071578b0f8dd0ea882dc44414b05158fc26406b89e55a440"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "042dc4ec152218944d198e83de31a58aa24e6ef8856d6c0db6fcf24e85daf777"
    sha256 cellar: :any_skip_relocation, monterey:       "21adb7d007f39400e0859d7a828e629e294a20439adbe0841d87f2dbbf0c18ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed8017417d750f428baf620d87df4ce278927c05965d1b6e7554d439e806b1c3"
    sha256 cellar: :any_skip_relocation, catalina:       "f62632126360eaad947698c2f367fe2b5edacf766d9c662276d0672d64cce691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf6b32eff4cf53808854f0f949a94cb3d4b9e8d417446491db89c4bef0bbb265"
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
