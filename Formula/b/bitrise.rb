class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.6.1.tar.gz"
  sha256 "5050929400f0650bc018e044ef825dd45bb4f039c4fe4096cb164886256069e5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13168bb8dc6626941be1de0a6eabf011d8b46ff915f70a07b629afd9ae4bc45c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d5a7ff246ceb723dcfe10bc9408d37e645709023f4676e8b49dc79f02729c98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9be3271397561d6f2290fb2e77a67bb173eba2f6bb6db8c745387cd866bb9996"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a0b929c3553eb01177ce2423626f054cac1dff5a3c3329f5996833f9b908fb9"
    sha256 cellar: :any_skip_relocation, ventura:        "196b624503423c9ce8450e648a2fa79fd4775029ccc5afd3007884ffe4f95abc"
    sha256 cellar: :any_skip_relocation, monterey:       "6be09066194ab1740dd4ca709b50f95d260f7293af4aebd4f99fac1c753ef170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d94874a187f4a39e83d2e8d8b906307057910bdfe1a592f1b9590d8f3b90cc69"
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
