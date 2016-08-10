class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.3.7.tar.gz"
  sha256 "5695c81f795ec46ee1dfa7fd8a895a1bb8dfe087748a9da7b4b2c8d877323a45"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ba8afc7e1d88a5150bdf207e59b8c841216b1ef8c317acdfc61230bc42a981c" => :el_capitan
    sha256 "e3e7572569b6666447e159f7c07811de021ff7a9f216de33a789554e4c1ed05a" => :yosemite
    sha256 "287b5900c7b13d2207ec6402b315de18a74a0562fbcb30f7c300e58de66f580c" => :mavericks
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
