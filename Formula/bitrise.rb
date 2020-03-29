class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.40.1.tar.gz"
  sha256 "6fa7e8f475e09e18cdef8acca7283e39ec8b0a1b7c27c5efbe861fbe35fc335b"

  bottle do
    cellar :any_skip_relocation
    sha256 "259c283dfd0f471577ebac8f72c75c93e7474be15ecda01ee7771af3910bfac7" => :catalina
    sha256 "c2983fb9e427e6254d9f67ca682c5630820da22f786626d447fe0f12890d918e" => :mojave
    sha256 "fc3e53dd707100d113e3247c67c962278916e7ec9e705f8bd8f712aed101b2b9" => :high_sierra
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
