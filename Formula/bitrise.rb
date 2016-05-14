require "language/go"

class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.3.4.tar.gz"
  sha256 "457db8a934a5f865307cceda696eb0667f3762291c4c359568b995bebbc924ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "20ae9995a492af2a5297db76fc5a8a6e78cfa10f107dc83993642764c172c9e6" => :el_capitan
    sha256 "bcf1733c9856bf6c1595bf1229b9e03b28f617b767597fc0f77fa5f58ed73a22" => :yosemite
    sha256 "3e24a13de7e3c595b104d3295c7529877cb7781e4cac58b9c1818b936aaadcf0" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  resource "envman" do
    url "https://github.com/bitrise-io/envman/archive/1.1.0.tar.gz"
    sha256 "5e8d92dc8d38050e9e4c037e6d02bf8ad454c74a9a55c1eaeec9df8c691c2a51"
  end

  resource "stepman" do
    url "https://github.com/bitrise-io/stepman/archive/0.9.19.tar.gz"
    sha256 "05c0705be8406d2b547f0ae7c6cb4d7149c12c3a7b40d16a63e31fcf274ad696"
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
