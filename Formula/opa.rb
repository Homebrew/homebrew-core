class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.38.1.tar.gz"
  sha256 "829234286a44078d70e646d307740f8d44a1d72b9304406519d1c7332398f15d"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc22c3963eb12a6aadffb47f3b924b8b81ae9b2a290cb6354a0589f5b2750900"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f46b08f9599e50ec099e0f8c67d9f86dc901ca2668925fc8c6a9156ac9a0a49e"
    sha256 cellar: :any_skip_relocation, monterey:       "4eef4dc6f8b8c8ab37185acdc280d4e851203055864a7f9d9ab71d8df9bc4e80"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa04ff7c700e29141b9b6a874cee032134554a5e8f409f5bd1bb10daa3610f1b"
    sha256 cellar: :any_skip_relocation, catalina:       "0ead3481cdee51be20011c30532da7cc7b6775c370d5ec55de58c98854330a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "587fbbfd7debdad67e252c98b64e854f521abfb6e4a4d9eab7b8bd9b7ba992a2"
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
