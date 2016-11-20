class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.4.5.tar.gz"
  sha256 "80aab3dfe8e34eb7996f98edb7102c8566af87616acf5f7a76a5012bb421d415"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6622c94fb2f85a5cff42f8bd946a70cc3bacb8539ed23de0a0c631fdc891b93" => :sierra
    sha256 "b5f6b52b2681c0a1247bff6c1d61fa074196d13b59c8211e87657069650b0e89" => :el_capitan
    sha256 "0fdca27cea011f0f9e3d32622ce845f2d64f6d8b2f2b2a1c20ab0899f07360d0" => :yosemite
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
