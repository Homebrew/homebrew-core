class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.12.0.tar.gz"
  sha256 "cdf3ed2fed7ec777e4a275804ddc6a3a4f372c6edd5ee216a8b63b8f3263d1a3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edeee17a08d64b4150e4991543adc2087c36622d248fecb5fce705a05a95d31c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e62b91032d10cb8fd96e567c9998bf9fc5d04275e51421723bf7765a44b2be6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d88589c374b98563a32c2929d82815d6b21da6c15c80569bf0edde03549160"
    sha256 cellar: :any_skip_relocation, sonoma:         "482d9736a00dbd62553ab933fd52dc6874e9698032a996459425a470f6971e45"
    sha256 cellar: :any_skip_relocation, ventura:        "2824cf20723383a455128f6796874a4934351a515b9eb6bfab6c1e95274c0a74"
    sha256 cellar: :any_skip_relocation, monterey:       "4295269321df2dbddf157b146c8861b678d413fec9f29ee8ae349195f78cd94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f96239fcd8c7eaffad961ad43fe86510656634919d218d481bcfceef8c1be4"
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
