class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.24.1.tar.gz"
  sha256 "50b445e1e042295f88e5bff0c1976ec6c56812fc8d3af1871f2d002a810d3f33"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d8952c2de3839807f18195ee1ccdb924c789e49bd690a91faf24f58161e7c63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d8952c2de3839807f18195ee1ccdb924c789e49bd690a91faf24f58161e7c63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d8952c2de3839807f18195ee1ccdb924c789e49bd690a91faf24f58161e7c63"
    sha256 cellar: :any_skip_relocation, sonoma:        "72ae9a0aeb871819dc8c4b0b5a48cfc0960cec98daf2584470c07df90414abbf"
    sha256 cellar: :any_skip_relocation, ventura:       "72ae9a0aeb871819dc8c4b0b5a48cfc0960cec98daf2584470c07df90414abbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa92be9ec12186916dab606a6709c5772c8842105238294f7e7eaefd1ac12aa"
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
