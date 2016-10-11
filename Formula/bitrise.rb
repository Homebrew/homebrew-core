class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.4.1.tar.gz"
  sha256 "d4a756352ff8249f04c96b0e03f7faf571d518c032ad84b3d74dbf830d119624"

  bottle do
    cellar :any_skip_relocation
    sha256 "184a953b39384b566a700b9de385b46ea59c5135f313a28d765a66d0e74fd832" => :sierra
    sha256 "81aa3e7dd7e7b59a2d3f738988b5b542215cf8c2d3c3f957ec3817e83c4713e5" => :el_capitan
    sha256 "4348bfc455b065af672e29c542bde6769f3938f7ff2426e0521a34b4d02622e7" => :yosemite
    sha256 "610f56df3975d3c0c1408c90992cfc42247ddd968ca0bd19592fd848a5fd06bf" => :mavericks
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
