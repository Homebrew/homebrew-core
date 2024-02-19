class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "797f8feb23bf91cf41ed9a0234758d9ae9818eb126efe92312edb67a394d5ba7"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24fa880bae92915fdde8c9dc60dd1d666f31e1b9f1629dc92e7e9240d6e2e64d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd220d0e034d1c1997458bb962321b29772facbbf3e3b05672d6138bfe883de0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b38ec9ad80fe1823e520903087545c5379788f8284ae1a54905f5f187002e7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "565c6bec2688f1ac2d78b034c6cc8c3aff3984b9b231a36977a55202800e840e"
    sha256 cellar: :any_skip_relocation, ventura:        "bfc0430b80634d956148bf5ae9434e3b11ecbbbd770267c69548071d2f253df7"
    sha256 cellar: :any_skip_relocation, monterey:       "dfd4bcc3317d6c18f246199ae24313cc13a316c2004b711c41cf3617c3c14575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1426ead6aa9e2b88cc0e18a276b5a84779a659b1ebf513560eb96aaa4bb4fd43"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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
