class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.38.0.tar.gz"
  sha256 "a4fa1aadb09d50fcd60477eb708d743807e73ea9c96abce436817b2da07e8564"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc20a5c2150a5c9531a772df79fd6286fbf1d6da1fd92a0244e1991dbf501fbe" => :catalina
    sha256 "72f4bb4352d77a4991d37eddf2549a034de2f5041ef936ab188c3c4b8591948c" => :mojave
    sha256 "1931d5100b853a5a271b0c3e07092ba71fa04eb2f341e142cc0aa2c024df533d" => :high_sierra
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
