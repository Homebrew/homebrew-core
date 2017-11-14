class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.10.1.tar.gz"
  sha256 "336026c1161d9450d7c3a287c7394dd5c68f1e4ed1a803d5ab4262fa4b06ec65"

  bottle do
    cellar :any_skip_relocation
    sha256 "de1fa632e9f6e19c0de49331375eb8d2147d449a63f2b8ba073fdb446743b5df" => :high_sierra
    sha256 "586338b64f7917ce92ab5c7e11cdfd5ca4e6cbbfb552c26e696f8ffe79bba4b9" => :sierra
    sha256 "fd1449601072eff17b219a0fefa211b3dc4161aa4df42c83914153ad4ce7f5c7" => :el_capitan
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
