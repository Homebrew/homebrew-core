class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.18.1.tar.gz"
  sha256 "868e24ccfb9a9c0e96eda0a2124ad912ff7754fefdab6519c1d2093acb939a7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f68c2cf69db0b6315748b251b839130a2a02588f514281d024c3c7c6b58d8568" => :high_sierra
    sha256 "c15528136f8ca5a51964b1679fbfb1fa6a681acaa7942696babe5ebda7a80319" => :sierra
    sha256 "4d9a30cd797299b1d67d10ee74377b990d5d9235f8938b596140dedf8bbc2cfc" => :el_capitan
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
