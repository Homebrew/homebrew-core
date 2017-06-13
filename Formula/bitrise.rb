class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.6.2.tar.gz"
  sha256 "10b2b3a654c2db03cf0a915f3c488974dc573a830f64c01ac14f7321cc0f1a71"

  bottle do
    cellar :any_skip_relocation
    sha256 "920bbb808265501593500f427f1da11a49635ab6a26b9d42cfe5397b2cec5079" => :sierra
    sha256 "1a2bbf15017f9f25da3d95779459e25c0c172b1b5dc8a3611217370def562129" => :el_capitan
    sha256 "ccb0e4047de9f8b92b31166a54cc353635f2356b81232028bb2bab177b09c7df" => :yosemite
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
