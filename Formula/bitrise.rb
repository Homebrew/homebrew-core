class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.22.0.tar.gz"
  sha256 "bf44bff3542ee2790d7331bee1d63ad561bd7df63a2f9a89c2048878d2105fe5"

  bottle do
    root_url "https://homebrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "b2109fc1a22d224f075767e0898057e30374dbd7f03411829ab7db98da9a72d5" => :mojave
    sha256 "e5fa1bd541dbba52a2302c3f1cc898c5b8d7214475733c36e906562f29ec8fd4" => :high_sierra
    sha256 "ed3ec5f67894d2837eb4d158126f82c515a6880271491dfbb746e7dcd228764c" => :sierra
    sha256 "4ad2d7bd87ec7bf66ab70708783daf3e98ac9c5156e994e68e71dd530617bde0" => :el_capitan
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
