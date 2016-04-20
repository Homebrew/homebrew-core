require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.3.2.tar.gz"
  sha256 "7954cc88e7be3e57e593e9290cdc77948950cacd5ae832922caa8d4ca7c6d004"

  bottle do
    cellar :any_skip_relocation
    sha256 "7618e61842859f003079feea78c80b7dcea1789e00e4084b297e17cea3686310" => :el_capitan
    sha256 "ced063e78fbc53c86ea4c78329bc38957a4abf2dfa9e7b165205ed625f019eff" => :yosemite
    sha256 "4c9eecd61efd594038d0c9d5542ab97a2ff69c3c0aa960300a840f3eda7241ef" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/1.1.0.tar.gz"
    sha256 "5e8d92dc8d38050e9e4c037e6d02bf8ad454c74a9a55c1eaeec9df8c691c2a51"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.18.tar.gz"
    sha256 "9aaa9c20d3a73146f32ab280ec2127c6c812cf86fe92467369d7a304fc6563f8"
  end

  def install
    ENV["GOPATH"] = buildpath

    # Install bitrise
    bitrise_go_path = buildpath/"src/github.com/bitrise-io/bitrise"
    bitrise_go_path.install Dir["*"]

    cd bitrise_go_path do
      system "go", "build", "-o", bin/"bitrise"
    end

    # Install envman
    resource("envman").stage do
      envman_go_pth = buildpath/"src/github.com/bitrise-io/envman"
      envman_go_pth.install Dir["*"]

      cd envman_go_pth do
        system "godep", "go", "build", "-o", bin/"envman"
      end
    end

    # Install stepman
    resource("stepman").stage do
      stepman_go_pth = buildpath/"src/github.com/bitrise-io/stepman"
      stepman_go_pth.install Dir["*"]

      cd stepman_go_pth do
        system "godep", "go", "build", "-o", bin/"stepman"
      end
    end
  end

  test do
    (testpath/"bitrise.yml").write <<-EOS.undent
      format_version: 1.1.0
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    # setup with --minimal flag, to skip the included `brew doctor` check
    system "#{bin}/bitrise", "setup", "--minimal"
    # run the defined test_wf workflow
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
