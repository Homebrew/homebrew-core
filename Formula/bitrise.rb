class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.40.0.tar.gz"
  sha256 "bc99268a56909ed3adae7a13f423f1bfb429012f4fb3611e5cff06d09a5a3103"

  bottle do
    cellar :any_skip_relocation
    sha256 "d60aa304754cb648e641e8b0d4c7f23fcc2b1d00a15d8c0b6b1e153db9f841d7" => :catalina
    sha256 "3f90af070eb6119662741a08d6f07227c16605079dad2c5067609cd47f765d8a" => :mojave
    sha256 "7ba62ee69595d0d4412e7a46c79f84101ba020d6241562a9b4b99ca3cbbaf38e" => :high_sierra
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
