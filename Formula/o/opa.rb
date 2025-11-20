class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "9b8488d1ff8255ed987aa6f7125d5ad2b85f9d2b3277aa5d206ec252240803c9"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f123e65fbdd647618e4dd53fcdf01e079eac685a84359b942154c9982148c0bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5f11ffdd1208d151fa6d16cf16ab6060fdb7416e477de7bc2c265225300d2f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "746e9dfc284230dbd5df60d2a4cc7ec03c84bad224fc0c655e3c2521e9a22d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "3709dc4a631d0f6c6bb4bfe50469b23506193f33bbf6d930d81b6a465e3927ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6bb65234ec9f883765d777fcc28a2ab26e4fd40ca59167d38df0f9d9c0d9d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7bfcf6c762db6971a7da226f6c170b6f58ded23ce823a22b369a3aec2d552d9"
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
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
