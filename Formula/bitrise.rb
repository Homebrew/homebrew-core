class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.21.0.tar.gz"
  sha256 "cba15184cf87383fbf0bce79a83e3971c0514db05c4c89c1badcd8514454e2f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "de70c8b1098da143a3778336785dcb37d824e4b4880db750dfffd83250168b8b" => :mojave
    sha256 "b4cd5b3caadcca98adc65b65a8a358da9a5b83ca8ea2fa642f08bf54392b2ef9" => :high_sierra
    sha256 "da833ad68e187c01765492f5728e1fc7247016ddea47a36a6e8e229cf26df371" => :sierra
    sha256 "20871bc1c156812f8b3502f818e789f69cfb26bbcd0b17387060393420ffeb02" => :el_capitan
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
