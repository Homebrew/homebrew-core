class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.2.4.tar.gz"
  sha256 "7ac44a327bc4c734ea67e01ca57eaf694184e0393fb1704f06665c7e79cfbba7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32c9cbf84efd24955a60d84fb66fa73f22d3dc8600e52b083ad41b514756eefc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b3540f5e1892780f61527f85e0e3eac5b70755ec5bb39e343f55e1b06279274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b4a947d1901401730d5c0314b724a5746627e62071ec1368369561a4c7c18d8"
    sha256 cellar: :any_skip_relocation, ventura:        "2ada476cfaf42b6d94358998f95fda816dd28ff98e83b87afd5efda91accc1b1"
    sha256 cellar: :any_skip_relocation, monterey:       "f5fea60f0e2af415d06b003d8214b865a8a6bd1ce9f698fbdac8e324fe38241f"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaeeafc6f0d045f975a46f95d216b2d0a8d271b19df66bc2c2f1381d9b27d3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca30d7f1c52d80db03d44d966e8d55de042566e106ac17c3de23f5646f16d246"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
