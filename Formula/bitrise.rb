class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.7.0.tar.gz"
  sha256 "20a7dd4eb148f0d1e50e6cf97aba22362ed35bf8f1c1e64d7e8eb9231291c846"

  bottle do
    cellar :any_skip_relocation
    sha256 "5870f2d165c786bca6bd110d264d714e531c68e01b85554429f12474a4291bbf" => :sierra
    sha256 "f54f4dc9b499a253eb5ac88bbd0c6c136e16064aa6df653b447cf30a8174474d" => :el_capitan
    sha256 "6d814f773566ce7b5e516ad0c6f1eef997ddf2fbbfb8cbd5b519fd5d587de3d7" => :yosemite
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
