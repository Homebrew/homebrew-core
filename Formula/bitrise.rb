 require "language/go"
 require 'fileutils'

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.3.0.tar.gz"
  sha256 "b95d648cd87f7d5ecc00fe12a3f3b20b2a9b2ed2442851eaf68e88a03e8d0d97"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c9c6d4c4a135d79fe4dfabf93e33550e3fb3d207d366bcbe7cfe13d88a66fdc" => :el_capitan
    sha256 "91723eb65af76465347356047ed7c38ce26b1e73bb578fc5e51d7c5336407a83" => :yosemite
    sha256 "0f32b8a62ab83e509a2dfdfbc4df9eb333b0e7d4a0eb59ccb18e50760ed7343d" => :mavericks
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
    (buildpath + "src/github.com/bitrise-io/bitrise").install Dir[buildpath/"*"]

    cd "src/github.com/bitrise-io/bitrise" do
      system "go", "build", "-o", bin/"bitrise"
    end

    mkdir_p buildpath/"src/github.com/bitrise-io"

    # Install envman
    resource("envman").stage do
      cp_r(Dir.pwd, buildpath/"src/github.com/bitrise-io/envman")

      envman_go_pth = buildpath/"src/github.com/bitrise-io/envman"

      cd envman_go_pth do
        system "godep", "go", "build", "-o", "build/envman"
        bin.install "build/envman"
      end
    end

    # Install stepman
    resource("stepman").stage do
      cp_r(Dir.pwd, buildpath/"src/github.com/bitrise-io/stepman")

      stepman_go_pth = buildpath/"src/github.com/bitrise-io/stepman"

      cd stepman_go_pth do
        system "godep", "go", "build", "-o", "build/stepman"
        bin.install "build/stepman"
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
