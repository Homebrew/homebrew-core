class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.20.0.tar.gz"
  sha256 "543997ef7100b0913f52f77b40b3441f82a6260065eaf8c06eb534792288ab29"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1381d6791849396b8ac75aa162075d3626bba9ccaf320a226980e29a25fef576"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4288b04c6283a346921cdbac38067fc2c469440bde23b2f0bdf9fcb17f44f5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "608d55e621f4bc7a8214fabdc94546b9488b08b589dad003558da3067af5f7c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f940b6ce34c3ea20d5ae07905175bcefc7b292f3749117b76511792144948f72"
    sha256 cellar: :any_skip_relocation, ventura:        "15e3e12478185f88c7ef4c29e6063e31fa1d1ad0f349c480a9c9fb9fcadacafb"
    sha256 cellar: :any_skip_relocation, monterey:       "1296047aafab98b51423cd337449fe4306af4d7166725c2134373507956676c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584ceb0440f49938ddce8c8fdaa478e1e84961510b9ea6493151ce76606c99df"
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
