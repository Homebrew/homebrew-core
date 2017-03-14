class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.5.5.tar.gz"
  sha256 "dfde668a10aad1f28acd83fded9c81efc13b28185db77d14884928eb37d4bc96"

  bottle do
    cellar :any_skip_relocation
    sha256 "658c73fc441b41a72dc88e9ed065ce2e90eea96d842bf2bf2179b6ba3bece3c4" => :sierra
    sha256 "57ed000fc0b37edcf25eabb0aa0ac1dba0932a4af23a9dae79f2302e5365f5ba" => :el_capitan
    sha256 "eb89fb54e0e7a1d3b4db8bf10fa3d33732f85a9a891a3c0a21f75b3b6e62bd18" => :yosemite
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
    (testpath/"bitrise.yml").write <<-EOS.undent
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
