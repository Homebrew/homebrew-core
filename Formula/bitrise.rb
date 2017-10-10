class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.10.0.tar.gz"
  sha256 "c9cf944f69dd5be79bd02a5799f5b69f05a2e12499f37e98474754f4ada454bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f950f212d246a57d79369f133ac44787fdfeb45a9ab3cd8bd446cffe2766ccf" => :high_sierra
    sha256 "e033f676bba24ce6201830898d1f3cdc899f2251b229b794910de64dcf0841e5" => :sierra
    sha256 "20357c7374dc77b25be005ffcc8addc0c9cbf9529b60c7cb9392ed34915d5150" => :el_capitan
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
