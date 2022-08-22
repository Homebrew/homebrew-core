class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v0.14.0.tar.gz"
  sha256 "112b3c9eeb6a84894c42f2f40490c7364bf45c8f7cbd10fec7b792805ed96eed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35e4d9a1e7bc563c53cbf39f19b01216e3193af24d51826880c86eb5a609d983"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb725ade6f49037d6128da204852e148ff3ddbe414fdbf80bbfbab81495874d1"
    sha256 cellar: :any_skip_relocation, monterey:       "04fcd6472e8eae44f0c170edc1d4524392e5ad2506222de7691a70042292ddc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "177924324da426db82d12771b0fbafaf0e6676ce64d72a384c9aa07e8c1246a3"
    sha256 cellar: :any_skip_relocation, catalina:       "cfcfaf4d91d6a4952828e37ef1434f2e12803fe5143d9a82e574f44a4200bab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d79cf6a080103509458689f16dc03656e5ca85d30a9996afa044dbe37f010a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X oras.land/oras/internal/version.Version=#{version}
      -X oras.land/oras/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/oras"
  end

  test do
    assert_match "#{version}+Homebrew", shell_output("#{bin}/oras version")

    port = free_port
    contents = <<~EOS
      {
        "key": "value",
        "this is": "a test"
      }
    EOS
    (testpath/"test.json").write(contents)

    # Although it might not make much sense passing the JSON as both manifest and payload,
    # it helps make the test consistent as the error can randomly switch between either hash
    output = shell_output("oras push localhost:#{port}/test-artifact:v1 " \
                          "--config test.json:application/vnd.homebrew.test.config.v1+json " \
                          "./test.json 2>&1", 1)
    assert_match "#{port}: connect: connection refused", output
  end
end
