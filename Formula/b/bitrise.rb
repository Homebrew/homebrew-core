class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.4.0.tar.gz"
  sha256 "61caad7a909cdec677cc9e16343cd2cf622895182da36cf282c64dfae8ff81ac"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd699f1e68fe43566bbec0ba49f50792976cfcd7f509f9c55474c59f85376146"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd699f1e68fe43566bbec0ba49f50792976cfcd7f509f9c55474c59f85376146"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd699f1e68fe43566bbec0ba49f50792976cfcd7f509f9c55474c59f85376146"
    sha256 cellar: :any_skip_relocation, ventura:        "84700a4101debc6ca4b5236cba634ca2adeb91d48d7dec698901807b5021c098"
    sha256 cellar: :any_skip_relocation, monterey:       "84700a4101debc6ca4b5236cba634ca2adeb91d48d7dec698901807b5021c098"
    sha256 cellar: :any_skip_relocation, big_sur:        "84700a4101debc6ca4b5236cba634ca2adeb91d48d7dec698901807b5021c098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ccbd1ba49c1fb88bcde9e9c5eb263d128ae13f576a6f520a27d9d801dde3b3"
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
