class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.16.1.tar.gz"
  sha256 "c4b3ebc9ba72a997030576be52e280fcf68b65c288f4e81cc99736de85f86939"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eece2f1a375125a564d108776d2e9acccd73047de166e462fc8ba9f8e7816f05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f59a6d611b552d991c57f9429a1dd68b7caeb17d1250a84e6839b4e0517645c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9431af32be363e614d1740659d496a6384f77ab67ccc403c6da6d0ef4a6655bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "724bc865e60fa37a3dda0bf1913f882670594cdd7ba163470867f4a2d9268d82"
    sha256 cellar: :any_skip_relocation, ventura:        "80e77de682e936086924deda6f5b38c11ec03836434b1dc19e097d7ff38d253e"
    sha256 cellar: :any_skip_relocation, monterey:       "b43796dca6c40db462a883ebeae6f6f3c2cadc8c0fef8dfbfa57ab9bc3fc98d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abba38d5385dc6ae00d04e8947cbdf2f99222bf8d3da253e6421df14eb9695af"
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
