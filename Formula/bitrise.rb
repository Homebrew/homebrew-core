class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.20.0.tar.gz"
  sha256 "4b40cc9ea66b23ab2dc2ced4f5e69cb19ef79c0f0fdd15c89a2048e7d8536b22"

  bottle do
    cellar :any_skip_relocation
    sha256 "0096b5497d7bba020d3756dab0e39ddfcc8274f326f31e9b0cf2d9f84754e89f" => :high_sierra
    sha256 "b692f6fbef050e17dfd06cdcba6778833c4f10bbded4abac3ef33a59a16d70ec" => :sierra
    sha256 "22cd08756d2b3b866aa147e7444c58f054a51ab423ab29f9497963a9d682e09c" => :el_capitan
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
