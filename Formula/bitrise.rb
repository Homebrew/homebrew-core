class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.4.1.tar.gz"
  sha256 "d4a756352ff8249f04c96b0e03f7faf571d518c032ad84b3d74dbf830d119624"

  bottle do
    cellar :any_skip_relocation
    sha256 "9279f9b82dea245d189577d992f67ca7162bf1ff570af645bea140976c0f3793" => :sierra
    sha256 "97314050aeeb8dd3416414844ecf162c6801b329b424a6138781f856d5dadf94" => :el_capitan
    sha256 "b727751dd24c0d7fe6dd480588af75c123e8d89944b620b29cfd8f456f5940ec" => :yosemite
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
      format_version: 1.3.0
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
