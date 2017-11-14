class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.10.1.tar.gz"
  sha256 "336026c1161d9450d7c3a287c7394dd5c68f1e4ed1a803d5ab4262fa4b06ec65"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9dbb77efcf648b013956d6b02a8eff4da72a279ea8f7983e0bcbd0d23d5c5fc" => :high_sierra
    sha256 "3ae2bda0e6a5c70994f550e366b0c95be701e9690db2f7964198061f4ae654d9" => :sierra
    sha256 "184b10ed713b1e3ea951ce243cffeb687b6dbd43fc7ea6d68364346ad19e7787" => :el_capitan
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
