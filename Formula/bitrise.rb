class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.0.0.tar.gz"
  sha256 "312c7c6a252dc1ad153136ed4d4cfcafc63c05f9a231e79367cc4e3480dd968a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "458539df6919258bb73979d5d237c3300c958f8798b13ca972662f5a5ec741eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72947e54f1f281ab4c8c0d5556853e1430d55a56c10ae9a6ff367e08054171fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8809524ad07269b35b5e8dc46ce9eda717e02e26df2abbbe951c2bedbc083e33"
    sha256 cellar: :any_skip_relocation, monterey:       "f8e33a91c15f1942c9139adc7bddac3f5f24b2cf6200c7dc0fd0d6e456541d6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5b16c4b3577665e3f457c9deccd59c1009736476886abd994d48bd6164050d9"
    sha256 cellar: :any_skip_relocation, catalina:       "68dbc3d20532216c9922801a9453f388fa5f6aaa18ecd8a88a5f4b6a932498bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf8bd004fa816d0e584994edc05e1067c7ff8d073e629d51053c0d1756d17cae"
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
