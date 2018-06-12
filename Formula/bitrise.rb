class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.17.0.tar.gz"
  sha256 "f7e06aaddd5cc50b363563cd52523c1c179c03c3365cc20eb4f883f0f6246df4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a5c8a7b996a292aab8e44e6017baa107579eec336c89bb19275a0f815abde7c" => :high_sierra
    sha256 "9632fa5a6a0dca70be8c6b26e1d8b12fe21b5e8f29b7e5ee0878cd254146b211" => :sierra
    sha256 "5d134503f6853662fd8fefbb792fe90114de67c2954b0f417e22c8aab38303c8" => :el_capitan
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
