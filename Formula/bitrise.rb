class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.5.1.tar.gz"
  sha256 "329ba79d117fae7a638ec163731c09ad593c647ddab4320bb415e1144e4c7bf7"

  bottle do
    cellar :any_skip_relocation
    sha256 "bddbbe11e8033969b4cf684e8110ba540cb14f5049923a850425a688db4d9cfe" => :sierra
    sha256 "3c324440ed9aee3fc1ec2a89695e5b73c26abe40e391a91722f82467b6c8a8f0" => :el_capitan
    sha256 "ce8512d90a2fe862eeb109f3841a5a30e858580d62d1715d655cc9e5903238d1" => :yosemite
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
