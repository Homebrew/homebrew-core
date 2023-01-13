class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.2.0.tar.gz"
  sha256 "1d049025db5e974ec865d22916b2cd3fedac226902faade3c7cd27b0560baaa9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9de422158aed6bd6045983f8f83edd45df7659ca56e33064dc006539cb217ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39a4219bd3adec4e4625b862563a5c56d20f114a128291be24c123b4ac9f6ae9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71811ec88504a516ad3237ac8e00e36c32077383dc94c866d06f1a391a15f9fb"
    sha256 cellar: :any_skip_relocation, ventura:        "7be768270bcdd1f6eb18c62dd25574ec71a03dfc312773bdac6f16a0a4b6baef"
    sha256 cellar: :any_skip_relocation, monterey:       "d857e878b5f283b89fb6d56edc387a360db73797708d7d86c1cb476effe8dbf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8454cda4f42e2ffeabac01ca8674e625f7dbd18851f21af10f8853ef13a27298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "118ffedbd4f55cfdd30d349674a49461c9989082707676e6cb414f1989ac4257"
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
