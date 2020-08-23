class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.42.0.tar.gz"
  sha256 "adf7c3697689d1088f08a3e5e685caba47b47eac631ecda7e79cdcf8c37bae6c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "be12010efef572c81e44f103fed0667d5e0919f04693360730cc3a23c783b9ac" => :catalina
    sha256 "2376e5b982ba2714a22d76d8605aebd5e5e668e66d79e79266c2e74ec7958161" => :mojave
    sha256 "120bd8f30c634d9667552feb74a5b1263b70fd06299537406a9f2dcde5ec13ac" => :high_sierra
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
