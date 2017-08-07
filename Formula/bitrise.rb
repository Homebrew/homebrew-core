class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.8.0.tar.gz"
  sha256 "b493e99d4eb05bc503a024ffc672c28f5addd13557462879644421e5c88ee6d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c47ac3618bd8e2efc0d770858c9e7b82d20d1e08fc5863bf83659cfbf9ddf184" => :sierra
    sha256 "bcb5b489dd85c1e12dadc687c11c4296234444db766f1ce1bda46b7e87a78f5c" => :el_capitan
    sha256 "0ca41d33cca289acf6a5b678ebd574a3c2a40bd493661cd1d82a6a12aa05084c" => :yosemite
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
