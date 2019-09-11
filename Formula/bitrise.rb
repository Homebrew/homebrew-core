class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.34.0.tar.gz"
  sha256 "6679b8caa1f7fba63829ac8751066b79b81e46ec1f130a1549585db45dada99b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dc83b0b14ba7c3c16408b5c73415b80dd51a568a04988f63bcf6463f755e22f" => :mojave
    sha256 "6af58cf201b006fffd86a98b6e0aa5fa941e42523969b72be7af53502ae977c6" => :high_sierra
    sha256 "200f128537b83039c1c5ff78ccb615b31489430d76ed1798142d2d499544db3b" => :sierra
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
