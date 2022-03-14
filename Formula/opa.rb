class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.38.1.tar.gz"
  sha256 "829234286a44078d70e646d307740f8d44a1d72b9304406519d1c7332398f15d"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c04e383cd017887e24192b0da7b48a5ef2f4cb57cfb36408f89a7857044d37e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "571541c8a1142978405568c6be308be1ea14dc63e12fef27df60f977802d2fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "72a94e404fd498636c23349091d7a5b45f90d357df72f4acef8e8a39725f851a"
    sha256 cellar: :any_skip_relocation, big_sur:        "53cd496c27fa5494261fc9dc4aa782a42b0a63126c6d7ad13853d3ba27b6f5ee"
    sha256 cellar: :any_skip_relocation, catalina:       "13ec842f290a553ce5a7543ac9ad979f787a395742cf5d0e7c6b0856958c8eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "552fdcbca85881a9640945154eefd66f4ee3bfefd0a521be9855b829078eca44"
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
