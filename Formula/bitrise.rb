class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.39.1.tar.gz"
  sha256 "6b4758927907a57b5ceb46f74a97481fcfafff12f634cc336877bb97b69602a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "254256691400b0d9e4f813638a9617a498f7923b6f5c6a0c1a130d1130baf01a" => :catalina
    sha256 "60bed9ed097c30fb17e60e1b33a3b71dcf8166a76c5db2cd2a93c78a2c0788ea" => :mojave
    sha256 "6c48063043f4190fa470b85c87a2206d32aa848fcd488c8329319662f4cfba26" => :high_sierra
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
