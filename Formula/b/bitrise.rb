class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.22.0.tar.gz"
  sha256 "3b930c90d0ff296026d065fb586d66f9fb5c7bd86267b417a4f9dbc6f7b07126"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71758acc4fb87e19eb1066c9e3afa3259b1aa36289b1986bcbc665a8d78b6d69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71758acc4fb87e19eb1066c9e3afa3259b1aa36289b1986bcbc665a8d78b6d69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71758acc4fb87e19eb1066c9e3afa3259b1aa36289b1986bcbc665a8d78b6d69"
    sha256 cellar: :any_skip_relocation, sonoma:        "daa0a19c4d35278af901e3a220a863551ad7660d536d85c09d7505e0458ce100"
    sha256 cellar: :any_skip_relocation, ventura:       "daa0a19c4d35278af901e3a220a863551ad7660d536d85c09d7505e0458ce100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400e7174f14c1540d406d171756cb0e7219c0967a3dfa729de06d4944d621b4d"
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

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
