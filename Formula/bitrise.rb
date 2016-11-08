class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.4.4.tar.gz"
  sha256 "647c2889ee694bd130a5b5d5382767a61dd64a21e4b897507196d44734242f51"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa2b078b8d3f6c918c257ce3f19d5038bad25462c5c2d474fdda3e96c95d5d21" => :sierra
    sha256 "602f83d9b60ae48c4b0d6bf9e635ffc625685513728ed688466a86f7984f4a09" => :el_capitan
    sha256 "225eb2b9ae51443d815ef40ae3da0b92e5e428c1dd8c43b40a68977339139aa0" => :yosemite
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
