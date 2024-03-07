class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/1.4.8.tar.gz"
  sha256 "5f62e277f72fa31eca8f180377979adab878a68a2a8b5e50e81c817cd1be2679"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0495db418ad422101df27d5a03888ed82770ead46a52712d1463a771748af682"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd59b4f9526ae81273a221e1bd8a755498722ab5f17000114f919ea085bf93e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab0260760df3815fd7d18a66c1e9d4fe539da07c54326d1b7b0526950adfc1e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "10aedb385eb332cdcf9ce44a710a1f115e3f65a643aa76add747f54ce9979e93"
    sha256 cellar: :any_skip_relocation, ventura:        "55d63242a91a9bf845ecee73108d4ad9dd209de90e114dfb136bed9c223c5793"
    sha256 cellar: :any_skip_relocation, monterey:       "f9d492c3e2ebc705b02be738aaf981e4ea168aa47f4f4cd49eb2b4ae88641a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b6f1ae1a00f6f98cefe4fd4bca9049a904f391f2e26df644647d187d27198b7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}/cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}/cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https://example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end
