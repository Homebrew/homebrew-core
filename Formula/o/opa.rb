class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "996ff51dc0c86cd0e330e7017313d24b1f35436c9c569701c24952087d301122"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "284f6dca86bdc19e8ef8449c3097ebe70b9b5dd7f1c14497b19410370b82b206"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e68d8e796d1c28bbdf2bc243838c4996ad4471c2241aca722877e078f16e73a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09d044bd2eaa3a4ea2c5804abdbd0f2d9bda643dc4ec874fb78c7c71d31e4c2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "eec864e2e7578ba54e2add5966eda9b81af8b173acfd6c7fcd2ad219b7b91bfb"
    sha256 cellar: :any_skip_relocation, ventura:        "c474c472d07491c192165ef7fb72cf703c4009a96280166ddff618c7c569852f"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1933578a9bbbdfe79483d33d9c6214d9215fef0817e14ed9b32ab2898790c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb997284434354dfd0a60ce5b0e008a9794cacfed7139b87aed53406ba4ea59d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
