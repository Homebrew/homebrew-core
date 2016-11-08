class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.4.4.tar.gz"
  sha256 "647c2889ee694bd130a5b5d5382767a61dd64a21e4b897507196d44734242f51"

  bottle do
    cellar :any_skip_relocation
    sha256 "844f250445ab787504280ce133358fda46d60a4bb0e773baf16105b664447acb" => :sierra
    sha256 "4c1a41e30b013e0088c598c1bf348f828bb14e6445c9ce63ecb80d75b04c60bf" => :el_capitan
    sha256 "71ea7ce0087c1727e0b3901c8e7ab10e97f790c65c1891000eac7586434f6d4d" => :yosemite
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
