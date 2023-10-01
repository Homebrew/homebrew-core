class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.5.0.tar.gz"
  sha256 "bb92dd43edabc77b30bf3e6feb89c461994c0eda5875ce40e176d0a29c21ee0e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ddbf7bef100695ef4d851efb9eaafc6dc93572163fab31a250d081e15f3baad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc3a411f1ac44683eec99171912653fa1fddd9b8823523bedb1b308fd1c3ffd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ba58301610bc3537e6ae77a458bc98ce10eb397a76c680c9eda60528056e270"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4aa4ba758719429522748f1efb5acb03195e242bea44d1fd35f718e8e7738ebb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f361222759470138c1292864317fee77b56aefc69cb7bbc0a9462e2fadc07080"
    sha256 cellar: :any_skip_relocation, ventura:        "c42b747b2e0003aed681f75bd53c68397374718c1c80c59d87745b8c5137379c"
    sha256 cellar: :any_skip_relocation, monterey:       "71927c7a81378376defce9957bf3ea6e4156fef33312486bc5443d63504d72f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5993846c49b6a92ebb355faaca7be92324fc57aaeca8d83f2dbe0300a50d556c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20f04c7ea6d2381c8c8863949d3576f8bd08e68f9e2487bd17a083356bb634a"
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
