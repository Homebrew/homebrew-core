class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.36.0.tar.gz"
  sha256 "1b8999a1c0b1d56e2113b2222d8e6214f6350af25eb10c5e39bb7f6e18a17426"

  bottle do
    cellar :any_skip_relocation
    sha256 "83b166d70e6ec9708d770c92f68c52cfa381737799ce03512879dcff1800875f" => :catalina
    sha256 "0955e039c7b22b065e0d7e2b90583af0b506a0a23833819277f23e15eae65505" => :mojave
    sha256 "1a5b0c22877f76d872e605a44d0e17f132a5fbac79e787e19880b1d3a9c5827f" => :high_sierra
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
