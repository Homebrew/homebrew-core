class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.33.0.tar.gz"
  sha256 "f7db95e558b6fce105f933a2288b3dedb2b83ef051bc9b6c3a27529a556d8b80"

  bottle do
    cellar :any_skip_relocation
    sha256 "54e8924d1ce385ccbfff6c503f20db79e062a69d69b3cb57375a198f5b7797a6" => :mojave
    sha256 "0b1e3146114675a173d6967922c86ea0bf692360ad42ec6998da9985b4f2487c" => :high_sierra
    sha256 "67d3e8d53cbd689963491c421a83d87bb90941f7b4701a8257fb83b8b9edc040" => :sierra
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
