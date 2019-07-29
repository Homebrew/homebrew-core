class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.32.0.tar.gz"
  sha256 "2001bdaed9b22f424e0c23a68f33a90f1f20366e87bdbdf8cdaf6559f589ab9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fb39cd625af86b7ffb91e03409e652aa78f307e2b8f187b5f574a09beb127d2" => :mojave
    sha256 "3d7842518de57e4743b5dcd5e23ff2d9ec487c6b539d33567902ba1cd5820cd0" => :high_sierra
    sha256 "b60774257b911e27cbcff9e4e5e47c6a50e833e3f7c7c3a7ad3f94ae92483f2f" => :sierra
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
