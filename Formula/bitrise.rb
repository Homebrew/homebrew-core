class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.13.0.tar.gz"
  sha256 "cb967a110e7d8dacec085d354eeb5cde812193e5ee6e97c52de68555b341f417"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c3618c62aa06944b2e99c09a89b6f115602396c38fd5ff8311050649a4f8126" => :high_sierra
    sha256 "6c24f396b7409537ea2606e8f8acf4a813eee1e8017beb9c7ca3ad54b12761e3" => :sierra
    sha256 "e85b92f3c787a43bcfd76eef71bd26f5e37d7eea8188c0f6182133b9c7100189" => :el_capitan
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
