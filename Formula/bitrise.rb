class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.3.7.tar.gz"
  sha256 "5695c81f795ec46ee1dfa7fd8a895a1bb8dfe087748a9da7b4b2c8d877323a45"

  bottle do
    cellar :any_skip_relocation
    sha256 "c59dab8e4ecb75848f3aff364fb1c8a532ea61ccc84fce97bb7e9fcdd8769d52" => :el_capitan
    sha256 "87e55365782beff8548bf93036adab17b92738d97a0a1c3539413ff1c02d6332" => :yosemite
    sha256 "85efacfcefd7cac83713a36af18abc6c4e2583279bb8bde0603f49bad1259cfc" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install bitrise
    bitrise_go_path = buildpath/"src/github.com/bitrise-io/bitrise"
    bitrise_go_path.install Dir["*"]

    cd bitrise_go_path do
      system "go", "build", "-o", bin/"bitrise"
    end
  end

  test do
    (testpath/"bitrise.yml").write <<-EOS.undent
      format_version: 1.1.0
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    # setup
    system "#{bin}/bitrise", "setup"
    # run the defined test_wf workflow
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
