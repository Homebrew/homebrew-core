class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.3.0",
      revision: "a91aa202a01b830dafa969bb46f168e9c44580bd"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11aa02562b53f6f6ebd80748d633549f049e784745bf704ce8d124e8b0b12cae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9617b3b4754c42287829ca82f6d3b9145216680d7ed6305319e9860c2922bd65"
    sha256 cellar: :any_skip_relocation, monterey:       "7406c887300ad4a93ecb518b40c0ce5a1974410913d9c9c748979aa389d5afbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb9c7fd4d3695713dd346e1611fea136d7e92094aeef24d176547087c8591189"
    sha256 cellar: :any_skip_relocation, catalina:       "703a5959c7211e7f4141ad0a9a494cddd75bde937688a70cec816636f71d7b65"
    sha256 cellar: :any_skip_relocation, mojave:         "562aaca8a4a8fa80505fddfd48f2ba607bc289ecdb1a09ffbbf60eafaa67a0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff97e561d860a24885cafc074416e569da802d82d8503ef6f44e8f59cd634302"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/sigstore/cosign/cmd/cosign/cli/options"
    ldflags = %W[
      -s -w
      -X #{pkg}.GitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cosign"
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version")
  end
end
