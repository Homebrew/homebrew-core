class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.16.1.tar.gz"
  sha256 "1bb0b7cb863138e6b04f64557569ce9070ff7794fa41378ceb9f0d445f31a816"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8ad4aab03f748323a03fbf6b66b39a0797f707c4665471216e3b7e858f13eed" => :high_sierra
    sha256 "0c98d79500a91a2b49fff163987a5e600b8cd70b2aae87ecb2f7694dac81b0ef" => :sierra
    sha256 "107db3a7a2e09308b09079e01eb5a7bcf3bdb3de65367565f25449c987347e8b" => :el_capitan
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
