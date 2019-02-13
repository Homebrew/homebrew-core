class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.27.0.tar.gz"
  sha256 "a4691f380d096e8dcd3aa1996c26363354c7849e669e3d1e8594dd7659810df8"

  bottle do
    cellar :any_skip_relocation
    sha256 "042af41db94dff79d7ba82ac267f408d8a0d4cbfc8dc3de77f96dd500e65b1ff" => :mojave
    sha256 "7751bb0c04e71484fadb4c02adf2426f6eecad58d99fe91ac481f8fdad0700df" => :high_sierra
    sha256 "43dda76da24093b0157b2eab5d48ebe70231cb1dafee99c4079ba161139929af" => :sierra
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
