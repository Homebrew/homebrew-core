class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "c2ecf6360148b0ab0eafd464d2dd25ad8ac703ffc9f03e472882548283b83641"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "681fa090d5b829e7bc83baa763b98f5243bc03ef1b5ec0474fb9c112d5e6678b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80984ce16ac720d2175497f3bfbdfe3dce917e4e0d459d67e7c8c2224169acd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b8a0298bd36d9eecbc995e140c396dcf1d8e90be216bd7e3155efe23d0c298"
    sha256 cellar: :any_skip_relocation, sonoma:        "37f1356a9a5e0de74143af56b3f026dad5d6a89b3e5427661ae092f62cb02559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5299671f45e0a21d1aeb54b67753f064838ad0ea4f7db50bc22fde28d558692f"
    sha256 cellar: :any,                 x86_64_linux:  "87db6faeaedf44feea37316b3eebea7de7ee85fcd3d80543ff900fa2f9fc90e2"
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
