class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://www.graylog.org/"
  url "https://github.com/Graylog2/collector-sidecar.git",
      tag:      "1.2.0",
      revision: "99c07ca667f2f3eeb9fc23afc1bf7f3152b002cb"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8013d5b34e9f52b7d951883398eec860fe67731f3997f88109a9950d0bc9813b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e7f81a1b6652d4174fe522b23862d39c8a6afaa55916462df45dafc5d96326d"
    sha256 cellar: :any_skip_relocation, monterey:       "a7516dcac003058d57f8264775ee352f4ef860584107f92221ab0a35b0149130"
    sha256 cellar: :any_skip_relocation, big_sur:        "a39e57f9749ee91a6ef524b6ab087616b8fcf22a35564da5b8318b6788fe787a"
    sha256 cellar: :any_skip_relocation, catalina:       "6d66fcf6c6a71ffeda378600d44ee8934674b1ba9df2c5ec0d7c90dd4dee09a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c7da214e88be65203ffab9c4cc0b4106b2dbe97dec451a9b5d1137907daf74e"
  end

  depends_on "go" => :build
  depends_on "mercurial" => :build
  depends_on "filebeat"

  def install
    ldflags = %W[
      -s -w
      -X github.com/Graylog2/collector-sidecar/common.GitRevision=#{Utils.git_head}
      -X github.com/Graylog2/collector-sidecar/common.CollectorVersion=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"graylog-sidecar", ldflags: ldflags)
    (etc/"graylog/sidecar/sidecar.yml").install "sidecar-example.yml"
  end

  service do
    run opt_bin/"graylog-sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graylog-sidecar -version")
  end
end
