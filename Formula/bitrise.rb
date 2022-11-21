class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.0.0.tar.gz"
  sha256 "312c7c6a252dc1ad153136ed4d4cfcafc63c05f9a231e79367cc4e3480dd968a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "716efd72183d05e58fa1fa6ffe6121b3185896bb9bcf93505dddb9ef6714a3df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb15221781bb556e6965f7fdc4ae85cba3124f6fbc1bed3368a79399be04d23b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "887a4e7edfd5f0176eeeca77782e31d9c7ae6bfcb2cc4a487c0615fd4e1b30b1"
    sha256 cellar: :any_skip_relocation, ventura:        "520d6293369cf3447120e0e02575ae3a0f45b62810bf249b49aa90cb96415952"
    sha256 cellar: :any_skip_relocation, monterey:       "41ee808d5f1a56774b3f6235c1470542512d71bdd4dd60873725429065676c33"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ae6a9f4919af029c0b7c8233abf7e28c700e44d129de77975aaf7c94dbd24d5"
    sha256 cellar: :any_skip_relocation, catalina:       "6c6a465dba0b245ccf542430e9c9e729d345e9bfecb8887bf6b50a47f529d20c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac5775d5cd65b468aedb07acc452a0f3e1a6d18babc2108336c79ed049faf85"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
