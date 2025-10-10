class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "8dc131aaf240f10ebe2a5589a192c0afa994ed70ba8475bc266aac98cbe36f37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fddb93f511c0493e34a9c54ac3009157fcb3804cc0deac76d27825a7d5f9d9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cccd874559379321de6be628d44e7e58d71e739a829a9e37a01ef2574e65a34a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "538640cfb059daf1abb05b7fae2dda402219358fd7cf6ba602b24d7e877ea63e"
    sha256 cellar: :any_skip_relocation, sonoma:        "029b0db579035a3863c3484666b2d1427ab132a8583560666d867f7e977f7e99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bafbfb6c3a13903ed18f1a0c1811540ff9df1f2475d282e8c0e1487a519c6305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3afce85de343ea1923f27c69a5c64e8e2fb4997294fd0efa70da981382cd7ba"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w  -X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bento --version")

    (testpath/"config.yaml").write <<~YAML
      input:
        stdin: {}#{" "}

      pipeline:
        processors:
          - mapping: root = content().uppercase()

      output:
        stdout: {}
    YAML

    output = shell_output("echo foobar | bento -c #{testpath}/config.yaml")
    assert_match "FOOBAR", output
  end
end
