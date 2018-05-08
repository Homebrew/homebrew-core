class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.16.0.tar.gz"
  sha256 "27330834a06020ddb91a053284e789d9e60060feb6057da294bc311283d2f04f"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4600e4eec91509b94e3c2e4c9c2e270d348f4c149f555a7f42afcdbfe1baa19" => :high_sierra
    sha256 "9c1cb7f09f47ca9c044b6d09bbf68b8ffb52eec67c4e47d32b0a12b1fef30311" => :sierra
    sha256 "b0483d5953ce1fc762304cf2e4dac1ee9b698abd6d834f52b9ba0ea0874e1b03" => :el_capitan
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
