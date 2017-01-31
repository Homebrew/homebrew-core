class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.5.3.tar.gz"
  sha256 "60e1932ff549f3762cee9f87395a8ab5bbfae44342902a38eef33363b8fcfee8"

  bottle do
    sha256 "5b465311a9f37945ec97d32c67b0eb3e3723ef9338e2609f9c974e83e5d7b3cb" => :sierra
    sha256 "1e58391448424f53c34b6b53b58863f7808e5982b3bda99f14c799356d7a3652" => :el_capitan
    sha256 "0670321b4c9d0df0c3bb237d24b27a8e83f36f2f9450ad776b443f4a513be94b" => :yosemite
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
