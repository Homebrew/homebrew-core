class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic.git",
      tag:      "v0.36.2",
      revision: "a7844a6d7d47c302df1fabb845dd22e4e4b70e22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57f8cd448ef3faa4e38f6a4a1988bc1d6f685ee8d7e82bbb6a82911d3565fb5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fe1cae22a6d610e168d49b9d51cbe7bb5376b7b73fc545f54470c7eb0f2fa64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a50d0a6236484c05de3ee10bf034219716b40585b434642bbc4dbbb36e347d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f1d4aac476761c85505dcdb11f01725b4228b1845eb7a2ed7f9041b88da009d"
    sha256 cellar: :any_skip_relocation, ventura:        "29baa72688cb04005d05ee92f70243ca8573dc477664d4712ab236a327352b51"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a656bfaed7c987cddd3415f1a895dab8bc9cb6d6300643289845cf636d5740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c74ef4c8d9dc0e5ec29571579c865a933fb8cc9c67ef006b3251550fe7cf5b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openconfig/gnmic/pkg/app.version=#{version}
      -X github.com/openconfig/gnmic/pkg/app.commit=#{Utils.git_head}
      -X github.com/openconfig/gnmic/pkg/app.date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/app.gitURL=https://github.com/openconfig/gnmic
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    connection_output = shell_output(bin/"gnmic -u gnmi -p dummy --skip-verify --timeout 1s -a 127.0.0.1:0 " \
                                         "capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed: failed to create a gRPC client for " \
                 "target \"127.0.0.1:0\" : 127.0.0.1:0: context deadline exceeded", connection_output
  end
end
