class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.8.0.tar.gz"
  sha256 "b493e99d4eb05bc503a024ffc672c28f5addd13557462879644421e5c88ee6d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "907883de13971642a1474c47bf877ca074be475b2bc21a20548918edba10f6df" => :sierra
    sha256 "3382f446abddf8a4629a22283bd9ec5ba3c83d9db3054731aaa408d2d9a40128" => :el_capitan
    sha256 "6c5394ed4c2d83fc804a44223f5b8ecc3bb0b04e94447c59a23936ad78779c50" => :yosemite
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
