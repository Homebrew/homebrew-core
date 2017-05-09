class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.6.0.tar.gz"
  sha256 "b4d9c5d8825fc23981c7a85e62ac92a4635b26186d229bc382de3cfccb8373df"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cc3421639fc463156c27ea9736719a8e1f3e7954da70a0868afbe3d9b43673c" => :sierra
    sha256 "5739b4ce9e5a60fba05baaa057bb2d0ccca51765666421c6b7b004ba23e98fd1" => :el_capitan
    sha256 "d4daccddcc4602b34bb31d4489c96132826d598a7d86f6525303bc9b01024da0" => :yosemite
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
