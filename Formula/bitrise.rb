class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.46.0.tar.gz"
  sha256 "019ae87f0a758c4ba592841fff34226fa3b20c96b6ec983a3c1ffc9da8e20315"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a44a0c7700008d453998f3013f725131e8c24ec46f5644b1a215e7c633e10ca8"
    sha256 cellar: :any_skip_relocation, catalina: "9fbb0ab7bf0dd83e0878fa6cb686cf89629f7b72ca1c3026930df383877846ce"
    sha256 cellar: :any_skip_relocation, mojave:   "2a2128afb4fe1614cd807d23f12bf775616bc471d412167540b5c1a17bb4c3be"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

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
