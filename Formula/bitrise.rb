class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.29.0.tar.gz"
  sha256 "40ad83a9a16ab5bacfc7f343d18ba6a183ab54a6db18d536f91af5b0e096176f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea0e9d8a3795caf24dc19f2b3249a011d7797654eb2ce6b0ab2b731e71b9f710" => :mojave
    sha256 "70211e7f6c30ea66c955097fa47975f21e59891bab44c699de686cc78fa29e71" => :high_sierra
    sha256 "1f9a834ebe56ce2e2f89cc222381cae079028ac6bd243a038f952b8a6c50169d" => :sierra
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
