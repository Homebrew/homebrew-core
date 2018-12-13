class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.25.0.tar.gz"
  sha256 "590494eb1e131f65b342f9055a429d96baca38d0518acd22b477644e276cc0b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "00ceb0f4b1733d9f103abb9e39fe40851622d3ca743d60fbb0a2ccabbbde9470" => :mojave
    sha256 "ed34b20c0a76c1c90b80ad33f2060b2d5c297d39b6dcf1aab8aabf2823037cd4" => :high_sierra
    sha256 "b1343e2ddd20f4e16d297e2fa16b59a9598f0e1ba6bd14858454f0a52b312f3b" => :sierra
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
    (testpath/"bitrise.yml").write <<~EOS
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
