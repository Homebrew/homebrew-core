class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v0.15.0.tar.gz"
  sha256 "1b1f72d12b2c9c9b869ac73ddc1bf9fee43b1a435e418a6f6168f339fb622279"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "295dca4d63c8237aa2997cbf7f1d4c4127f11d1d02371402eef872f7bee2b147"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c888364c1776c6ac9ecfca313d0120588af1db23823797d333cf4913b9c5bf9"
    sha256 cellar: :any_skip_relocation, monterey:       "6ccd5cc4ec66cbc091ea0cd70b8dccf13e9cfe5153bf0f2fe10b3179d4ffee77"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e94939922ab6f2eed00190ece18cd033a441a22810d90aaa46cead418d3244a"
    sha256 cellar: :any_skip_relocation, catalina:       "67191f5046451d48e8daf57f7d0b5b87f749f8bb4f4b6030bc172988747319cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d93c180e60d0da16b814f79d3458c0c7fc2a449546d8074ed4b04576b2a1c8"
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
