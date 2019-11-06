class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.35.0.tar.gz"
  sha256 "f7efd25a0ba04c9619ec902d9949c34edd4537b8821ed32ac0c03bf4392c8906"

  bottle do
    cellar :any_skip_relocation
    sha256 "56cc6941a6e8db0d2dbf065669c9fce0a9077f64bb4b135665153abd47a30acc" => :catalina
    sha256 "aead5b64f31385c1ac6395ac96921a3c6b796d21648f0f790f1e92c3a1d11c1c" => :mojave
    sha256 "f179938ef149469e7049ee5628c4d155999d615cec701d5bf0af13d411c722ae" => :high_sierra
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
