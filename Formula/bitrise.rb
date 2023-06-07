class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.2.6.tar.gz"
  sha256 "031c51ccb3808ccd1c45c50b62947d31831b853e55b2a4c9e345978786903796"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ed095be0fb5c770d39c52bfabe53757ad7d690a085f286bdaa1ebdd585b902f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ed095be0fb5c770d39c52bfabe53757ad7d690a085f286bdaa1ebdd585b902f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ed095be0fb5c770d39c52bfabe53757ad7d690a085f286bdaa1ebdd585b902f"
    sha256 cellar: :any_skip_relocation, ventura:        "75b219dbd3ffaa458fe544e0e09329877c080b1ec1b071560172decb84c014d3"
    sha256 cellar: :any_skip_relocation, monterey:       "75b219dbd3ffaa458fe544e0e09329877c080b1ec1b071560172decb84c014d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "75b219dbd3ffaa458fe544e0e09329877c080b1ec1b071560172decb84c014d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb28306da973aa413b3820e30bf2a8bb26a5e3c0a115585b7e47b74c7e2a621"
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
