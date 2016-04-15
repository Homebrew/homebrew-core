require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.3.0.tar.gz"
  sha256 "b95d648cd87f7d5ecc00fe12a3f3b20b2a9b2ed2442851eaf68e88a03e8d0d97"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e7eb5b7e67178caf3bf7595dcb1fb9714b4ea7cd0f6d5ecf12c8a6e2bbbe593" => :el_capitan
    sha256 "447b79897dd3dac8efb3c5c7d4e40c1e74f4cc99bcb619f71e3d2829ad3173a2" => :yosemite
    sha256 "b48907dc00d4db572a8a9558ce4b24a5c0e625b9a0b2b2d643268e2b1b612e3d" => :mavericks
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
