class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "8b785f0789d5cfac94653661668693759fc8cc0fc3d8d22ebec479ba1438e734"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b61b1444f58c1f9be3467da714796f39c4d4909866405399baa1e7934da3530f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64f7927727e895ba51e4cbcabff5c33c1b7e635ecdd4bf254b29043dc843e54f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00860240f28371fb4843c893e709ddfafc3372eafb57246a9ecefeab9116fe5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f67163a32f0302f88938908683edc1267cd44dd2ed48a9ee70bca2c289108bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd8aa9390f0297e89591caadba7116e9608c11769f35690136462f5f98d4453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c47247d2cf1ce7c5d54d090688b1ee0618e1aee873714cf5e53d35c68476a205"
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

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
