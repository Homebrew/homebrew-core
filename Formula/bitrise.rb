class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.11.0.tar.gz"
  sha256 "c334b6ac6d8e486bb1855482240a154d6e46b0101fcfb872466236e411f18478"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1571493d3e1b6049d8f94c21054db1d3e3ed092928a9623908b75c7a6f58493" => :high_sierra
    sha256 "6a31a2fdf1eab5d96a49276d1fb0f8583e335129f9255c9740249b9a09c258cd" => :sierra
    sha256 "63f3b60617b9a647071f74bdf7f87cd858e885b53e8e1ff8c0807226f5d414a8" => :el_capitan
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
