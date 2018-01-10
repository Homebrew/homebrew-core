class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.12.0.tar.gz"
  sha256 "4a3bd7e1589106e32a8853d6cb1d71b76bb939d0ec4999b1e119d8e3317b0b7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "790b0cc86d342cc8607e029eca4f803c4f04ed1572a5949c14d261c4eb01cfac" => :high_sierra
    sha256 "f07080865aae1343fd046831037eff2657965215fc67a3484e238be37812a39f" => :sierra
    sha256 "eec6197748d7d505abdef230692f229b280ce1de02fa773a87fd40f113230c0f" => :el_capitan
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
