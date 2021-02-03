class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.45.1.tar.gz"
  sha256 "ce42200fdafe8257b01d08737545e86b3fb64c8462d08bf2a1d6b392b2b432ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "94677482e08cf0f6315344f2e00f2b9c1e0ea5877792953839b59476d564a748"
    sha256 cellar: :any_skip_relocation, catalina: "b2596a0246cc263573752ba45819a6f19c6093e6a9cb2c997bde69549616df53"
    sha256 cellar: :any_skip_relocation, mojave: "48303d2f3b5a46d4eae1a1a7770c4cbbf41bc9de69c4bd82f17960230e3b231a"
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
