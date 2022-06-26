class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.49.0.tar.gz"
  sha256 "c2afef0eb63127a14a6cda022f22690c720e355bb4c5ff44562d6d3e2c1c793b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81eb15b00634516e0c7457965048c3464e484df2b3c492051a9696356c30eab4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a25f65a17cc35bc32470dc500717d55a16e315737a0b2c2ac2dc6e5285b17da"
    sha256 cellar: :any_skip_relocation, monterey:       "49cf56e901dbac1ca276931344d8d77aebce8fe7946452a71aeb0d7e293efdcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf1ce60cb3239060544c53109e3cefb9565af3851c4605c780bebf9f98f8ffae"
    sha256 cellar: :any_skip_relocation, catalina:       "3f2c2ec5772bfa1e6995ea6d6f11b143e2ce69268453a50d62cd5f33b1d7e6d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1669dd43528c4ce3932d381c7d27b906f0503cea25b654da7dc99a514879c6c2"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
