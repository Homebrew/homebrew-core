class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.48.0.tar.gz"
  sha256 "0800d63eaca091f6570e227dec26560483ed6c74ea43558781fb717b5dfbdb42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21b4b70f7fc7787108da2671dd4f579260970ea5d8cb691054c55ee5d2117558"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "973602302d6b4270875e82c41709f8cfe4171a3bd53c271ce69a199d524f3aa6"
    sha256 cellar: :any_skip_relocation, monterey:       "e68b5c2af567d68dbadce954b4be9e11f64a867f4087fd397b33796a4eb95437"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b200d18f14e18e611c3fc9a98a6c1ef656f85d2f8d4df75f9d98c8a77067762"
    sha256 cellar: :any_skip_relocation, catalina:       "5f7902cce52a17241873c3a172e018bd874dfb28f9159a838aa6f48cc3100704"
    sha256 cellar: :any_skip_relocation, mojave:         "746b543d056b120d00af803f2170be17b3648c5fc7f8e100aa1d367817b3cf50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1609e537cca0ea8a5452b30eeeae470d8663f7942e2fc28b7e72c518d7bee9df"
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
