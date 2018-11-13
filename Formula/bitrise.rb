class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.24.0.tar.gz"
  sha256 "ff332860961ac2f2109d696c95355f45cbd1f3fab054b8127689794708f11e52"

  bottle do
    cellar :any_skip_relocation
    sha256 "f32e2b6a3d13a71036f1c835a541cae101fdf538156fbbdfbcc6867298edb52a" => :mojave
    sha256 "9567b53fb2adbe81dc930de3f6deeb710fbe837cf9f4be6533c1ca17066b3460" => :high_sierra
    sha256 "8694100553699e93a1959c388e0e3480292dd896276491b95ef233938b49d7d8" => :sierra
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
