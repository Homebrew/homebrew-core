class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.35.0.tar.gz"
  sha256 "4107a58ee7e6db9304924ce77c1250a6449dccc3f6f7c1abb24b9fd457c3110d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31394f50d0a9045503e837354026ea166d982ca93cb7075f52edaa3e18eec34b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2ba195a3e0f31f2d678e7fd30b7f2818d410293baa818827a4dd511df87a027"
    sha256 cellar: :any_skip_relocation, monterey:       "39c4ad7bc1d232ff4cc1155f9b784f7354f21ba12a806844d6ff3fa55ccae30d"
    sha256 cellar: :any_skip_relocation, big_sur:        "036422c4f762d1bc9dac96770df7d0cd64786cc072c7e9ff8defe74166a960e0"
    sha256 cellar: :any_skip_relocation, catalina:       "ad3cf40d5cb8cc1ec760a26cc8e4030871e8b40bfa4dc13d10e4b12a462434a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a541845843d9f995ed20f33133450e16ef22bf07e4c552c279d52868b61fb9d"
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
