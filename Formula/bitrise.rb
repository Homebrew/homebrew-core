class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.41.2.tar.gz"
  sha256 "79aaa351a725ee85148607feb2bf2283aa4e89dd325a9defd9cc28422d9d400a"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ff67c69c9852d77fa61c5d622059223cbd0b8ad5da38f2b7e287ae339084a00" => :catalina
    sha256 "5c3b5901cf29ee4773d6a2ab3ef5e81df4db17f0a5828c0c4ea6b8e3841793e8" => :mojave
    sha256 "7eb5623334301f3abe146c3b636dfd116a32a813f268fae8962a7d4d1f54cc8d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install bitrise
    bitrise_go_path = buildpath/"src/github.com/bitrise-io/bitrise"
    bitrise_go_path.install Dir["*"]

    cd bitrise_go_path do
      prefix.install_metafiles

      system "go", "build", "-o", bin/"bitrise"
    end
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
