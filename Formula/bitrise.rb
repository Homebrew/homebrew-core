class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.38.0.tar.gz"
  sha256 "a4fa1aadb09d50fcd60477eb708d743807e73ea9c96abce436817b2da07e8564"

  bottle do
    cellar :any_skip_relocation
    sha256 "51b449c3c06083188cb5cfb79f2e881a550d682e497e2467b2cb817b28cd19aa" => :catalina
    sha256 "bae5d7a2e71d8e81a9c5de2d49101006ca9bbc93c601b9a86c4af3a60ea0aaec" => :mojave
    sha256 "301492997cd69855212b75b825011be0b501321528af836dba25b845d010c9ae" => :high_sierra
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
