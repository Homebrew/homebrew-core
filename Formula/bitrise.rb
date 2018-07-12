class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.19.0.tar.gz"
  sha256 "d5657b7f5bf2585130afb97a4e7afdee013dfeeebd8e887e5085a9476b23aa7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "291cb51e61e7179d7af1c9f97e3d203bffc140ce6634c7f0bb8061e5fc109835" => :high_sierra
    sha256 "28b118b49f0ec061ef171714c7de18da7c84f0d4f6425e177c4baddffed10ffc" => :sierra
    sha256 "cc9763e07112f3d36d16cb9dcc5109c85d029545faf5794e06256493cab2c58b" => :el_capitan
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
