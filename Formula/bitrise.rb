class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.44.0.tar.gz"
  sha256 "f71d01b4dc1ba8f6719c01859526f23edd1d7b493f8ab098e2b32e9d1c84aa9b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1140b9568455794ceb38150b65154ba25b9a769c66f639f2b9055b74bf92b47" => :catalina
    sha256 "5b4dbb41ad4ed225807356dd794ef854752f177ba20866f73985f36c037806f6" => :mojave
    sha256 "b814ca00dbbd74aa5ac726bd4914d55faa0d0bc929744b677d7884fec6783455" => :high_sierra
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
