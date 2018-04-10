class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.15.0.tar.gz"
  sha256 "f2a0848befb5c9e8d952330076497d214db172ca16f98eb4c7933c0d6b257bab"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dd3d4dde8eee7c905da86fcd6bb0a1be57a730a90ded37d0e623b8f12277800" => :high_sierra
    sha256 "f5245b8decd9f986b4da0f9040872cda0cfaea78cdc610974860a22328642700" => :sierra
    sha256 "e8640007446a0e550c180e868f4802f5b005752764c5f71900e5dab600d1c27f" => :el_capitan
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
