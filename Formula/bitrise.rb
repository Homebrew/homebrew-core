class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.47.1.tar.gz"
  sha256 "1b4f6bfbbc061434e5af4dd022f1caebcc3fab3ae39af147d56360151c700f97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e31a0bbe0c5b46c0c1ade1f7e235b37c713abfd9d21408f5507b4b9d336badde"
    sha256 cellar: :any_skip_relocation, big_sur:       "656f3a5220952274653122a3c90b881dd0c24a1d52c7d747713d2cf44ebd0d8d"
    sha256 cellar: :any_skip_relocation, catalina:      "f15fe63fd0c1f9613fd9d2e9a5d8cdedcc78c8ea818011b8c7b4ca7a4b412d3c"
    sha256 cellar: :any_skip_relocation, mojave:        "683028a7cf49a0ce400979c9ab5501303af1650014eebee4b11bb78b2fefdad4"
  end

  depends_on "go" => :build
  uses_from_macos "rsync" => :build

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
