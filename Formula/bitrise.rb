class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.44.1.tar.gz"
  sha256 "979bbbbd20b90695acb6bb82a94400b2e485c4406a5e0a7be43419bf223dee91"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e6ee861f087d4f292102006d30f8e65e941c640188efebf29c1c303f2bdd07c" => :big_sur
    sha256 "5ac037f160d5e1501559883a2e768d27a2a9cdf6e64db72db5f917d771d58ce0" => :catalina
    sha256 "194a587583c0a716b1f0d789c559c71e744f48d4d4f3aa7004e60043b07e32ce" => :mojave
    sha256 "019485b3aa3aefd9d274d4499f1b9bcf9dbaf7a2d6bf996bfd79f01974b5f462" => :high_sierra
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
