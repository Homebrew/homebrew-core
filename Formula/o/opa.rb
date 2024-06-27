class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "7a7d9ba85f3cd1dc1f6b9c2ca9683a77a4e254fcc54daae5aa7e70c4df39eb09"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd32fd87adfa10686734fb9e2ce48ab0274dcc333bfb355ba2534cf50fe03b62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "754aa90ae1d2f2abed9ddee90c04a8a8023c004bce892dad32c3de0ac5c40365"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80a59eab9fb38c3c9bb3f76ef23f3a522dae9a392ec58039dc1524004ccef33d"
    sha256 cellar: :any_skip_relocation, sonoma:         "232d200ba23355336d9ba38a317ecbdca431291acb3ea45fb2201a528b9dfb87"
    sha256 cellar: :any_skip_relocation, ventura:        "2eb315724978a126b8f0dca27b6c340aeac3bd8baf86eb4b2cdc8e99cd237188"
    sha256 cellar: :any_skip_relocation, monterey:       "253faa8bbbbffa6348b162148c3e9c9068888ba45e8a33cdc0461f47d32e4cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b374ec871352437bcd46c30317f0c5ad71b7049739d6223de2144e48efc6385"
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
