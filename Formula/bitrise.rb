class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.26.0.tar.gz"
  sha256 "5126101216a8f756285c40a2deec83d806133a7a5136453c39b5b1a5c642432a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9bb239428a743afe7a42c08b9b30adddd01f91ded3dd8cb0a5dacd73a14619f" => :mojave
    sha256 "d72fe08e0b34123e086d0cd0876f76927e9832f411c7ea64e86da5e76f453c9e" => :high_sierra
    sha256 "4b5b414f71e0e990698f69df836dbe135ef04edbf3759e078847bf8dc58d46dc" => :sierra
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
