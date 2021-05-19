class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.47.0.tar.gz"
  sha256 "d7055b194c76f412b5d9dcbbd50bcd7c7c2e3ef8f4688062116c870b352e68f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "60c88f3e8c3e8d1502a3077dfbc6e7a7c6cc4aa4de40232d5806e35cc7ed7a66"
    sha256 cellar: :any_skip_relocation, catalina: "97d8a8b544b3745bea17eb5df862e0b2b552a43df6b1febb5c57b4655af2d42c"
    sha256 cellar: :any_skip_relocation, mojave:   "fe7e57492b270aa54cd10b78e141d4620905ce82dcc48f2cdffdf73455f1af81"
  end

  depends_on "go" => :build

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
