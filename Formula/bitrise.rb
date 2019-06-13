class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.31.0.tar.gz"
  sha256 "0a8d7a89929f40b03544fc74ce04c513667539225b6d10b2190dfba3446fc3f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "0601fb769c641558cf69955783b8af40f053b1915c8a2c790f301ddc1456df51" => :mojave
    sha256 "4cfcb752a890628a42f3a3ee6894dca6eb166e9229fdaa339bfea38c50b229a0" => :high_sierra
    sha256 "d39907759620f1405ccd2bd439f17738e7d6787583aa6857f8c996c12fc6917e" => :sierra
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
