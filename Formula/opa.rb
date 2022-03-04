class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.38.0.tar.gz"
  sha256 "e5a2b3de452caced85a7315cab80a304939323bcde9586302ed1775dab219f84"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d126b69a392eb55ee686263018bde088a2e0b890c1e8a5aa6f6c7088045e602e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f9f0d7c5315e0ab4a242877a312570fae3e808efaeca6e89b1925ea61c55226"
    sha256 cellar: :any_skip_relocation, monterey:       "b761296a05723f9c047477df4267037b913273efcfadb6a8bbc809f9fc5f7cd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "47012b445fec2f643290723904ee241218c10d5d56d7630d123fcd1b2dfea9d4"
    sha256 cellar: :any_skip_relocation, catalina:       "74184a0f777dd4bebe97f58a1f8d91a1804ed793786c851acdab6baaa5d47a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc06df2d2e3ac5ff53ccc78aaf912be1b60d77c7e2c458359c6e879d03c44b77"
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
