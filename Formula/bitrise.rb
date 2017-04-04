class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.5.5.tar.gz"
  sha256 "dfde668a10aad1f28acd83fded9c81efc13b28185db77d14884928eb37d4bc96"

  bottle do
    cellar :any_skip_relocation
    sha256 "41f8ffd25c2f9802dde293f31fa9315eda4145f19a4fbbf17520d59aeaed9108" => :sierra
    sha256 "8d241455b04543f6400c34a6ee3150ec8a9a2592deacd23280ee20ce48d39cef" => :el_capitan
    sha256 "80ca8f3805aa465f207ce6266a9288f71eee100be30a8b5c7e3e5165b2c9095c" => :yosemite
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
