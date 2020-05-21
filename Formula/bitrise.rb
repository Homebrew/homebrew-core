class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.42.0.tar.gz"
  sha256 "adf7c3697689d1088f08a3e5e685caba47b47eac631ecda7e79cdcf8c37bae6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "962ae51a1302668cd47ba67a06f458cbd049944562c34b202c2d07d200f27c3b" => :catalina
    sha256 "eb0d08ff9c80c70f3fe5fc104eafc30a99788c022d0e7ee199cac4ef20a824c4" => :mojave
    sha256 "099efc5cff3fa5cb0905b3641c399d80d3e87e70b25331e327bcc509c1ba02a8" => :high_sierra
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
