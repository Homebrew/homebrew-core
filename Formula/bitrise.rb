class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.19.0.tar.gz"
  sha256 "d5657b7f5bf2585130afb97a4e7afdee013dfeeebd8e887e5085a9476b23aa7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdb4dcaca3451789676169b156c16d199bdeacf5fb389cc1f7cbcead5b3c820b" => :high_sierra
    sha256 "54f0142bfb75ba28d63f060fff0236e16632ed0ee1f1bde1f23549f8ad907b3c" => :sierra
    sha256 "731192e76811da0ce9322299c463e97c11f126cf3e45bd0372b967742a428e61" => :el_capitan
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
