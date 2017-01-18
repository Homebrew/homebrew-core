class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.5.2.tar.gz"
  sha256 "63fc733ed35c3a0ab1e111d2c101865832bcd1bd92188742d372df95a4ebc075"

  bottle do
    sha256 "df413a76ce0de41ebdb4d81b50bf3e3ba5668c4aa7852ed69407e5b11684005b" => :sierra
    sha256 "c8c2101c0b8c07d93217a7578a19c776b487ecc43194cc0bbad4d8bf8e616eea" => :el_capitan
    sha256 "c7908d173855ed9ebefc4a4ed302087390a673c35d3c4eeb073354b6946e08de" => :yosemite
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
