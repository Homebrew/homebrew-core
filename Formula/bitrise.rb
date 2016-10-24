class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.4.3.tar.gz"
  sha256 "65641ec0c89064470875af20245492188b776bb89709c731eb7642c2042b96bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc4dcdf0ddf68654f4acb566ff9870c122ea83d6a81317b404cceecee5a2ada9" => :sierra
    sha256 "2f32720805469a3e46853b9930823de48f5c63c8d8c1ff34118267389ecef1f9" => :el_capitan
    sha256 "ed07f28956db844dd9eefca76298acfc3b95d89686ea03d2c64b77f9ef6605fa" => :yosemite
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
