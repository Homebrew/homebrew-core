class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.3.7.tar.gz"
  sha256 "5695c81f795ec46ee1dfa7fd8a895a1bb8dfe087748a9da7b4b2c8d877323a45"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f60e831c3ab63c9fd8aa60ff5741443a3b16c014dc722128a05f34103665ca14" => :el_capitan
    sha256 "2cde42085755aa6bc5185272f317076e819b0e0406a4033c636f9956853a2e8f" => :yosemite
    sha256 "2825b17cfbae1fbfcb119e5634bc01737c4632cf5c9aa0f30ed4fbbc5ce0f834" => :mavericks
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
    (testpath/"bitrise.yml").write <<-EOS.undent
      format_version: 1.1.0
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    # setup
    system "#{bin}/bitrise", "setup"
    # run the defined test_wf workflow
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
