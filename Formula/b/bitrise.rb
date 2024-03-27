class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.11.0.tar.gz"
  sha256 "70ce4e136f1a6655c37a52474ee8f3808e5e915bb63d12ff236df1efafe4ad06"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4c269718109bed38092dfaf138cfb2ea78c3b3d0162854e79c83c29e0891cbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c828c8f541c055f15bbf7af583804127188f166fbe968c5cda41f67d231c4b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96d5843e59ba3286d377f2690e0240cd7ff9b3da900cc7ae8abbcf3cec662d39"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b520a2997fa5834ab1ab2fc44150764871d3f1abd7041efab6f09731c9d49c7"
    sha256 cellar: :any_skip_relocation, ventura:        "302175b447f254058bd06f617f3d19d3352f4538e832cabc3cf5fda8ff6e3cad"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a871e4e1d351f5f753af6c72808716a9ec78b4b5412c83e2e444e90df2a20e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164bdad71462a541e3e6f3fc725806fad09dbecf4be7c507d3235c429a83afe6"
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
