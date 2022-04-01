class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.39.0.tar.gz"
  sha256 "19d51c03e940e914da4f707f5095cb1e3d6e0d5becb07bbe916ce20f30355197"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aee2eb0d6bee17b8da29f307f88bdeeec1e144bd4baf1a9a2ab9d445e6fb81d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6748b0b70632f216835bc0d87ed255653302b2e281bc41351a7e73c2539f25d2"
    sha256 cellar: :any_skip_relocation, monterey:       "ca52dd9795cda215c9c0f0dec5665ead404f27fc941ff642121c0e8159fed124"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a8885440384120ea9deda007eb161ac68af7e0ddbf5805cb9bf89be4a9b5299"
    sha256 cellar: :any_skip_relocation, catalina:       "08c4fb85bdb5e7c10ee419ec0775de99337f11360304bfd9e11ed3817143ebde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b3dec86f640ad968b6890af1969168b64d62d499af08b90f84745d8a85c4a90"
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
