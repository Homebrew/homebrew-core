class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.49.3.tar.gz"
  sha256 "6af2f55c08a99412af6fc2dfe439515ef7dc666a91eebe10632b496e8c4f9d63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a94ac912c0557d36106abb54371d802c73a28ec7651bdbbbd6d1087f0ae78e78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a95e76665e081a0c8a2eebd6cc32c02f3ddd181cb301b7d1c9f35a3a3f1d2069"
    sha256 cellar: :any_skip_relocation, monterey:       "a09001ddeb322bf7e4c62dcd67bc4f1eafa33f5859485fefcad898a9f5040afb"
    sha256 cellar: :any_skip_relocation, big_sur:        "02374dc88d102aad2c0669a64a2fa12e062d9d8127ea5b06b3f4973298b48ad3"
    sha256 cellar: :any_skip_relocation, catalina:       "c82bf151c5b507583186aff69f7e50ad13222d3e8590e233acff5b5f67c5f4ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bef2bf5525972ff7056881d7bd1c82db3962eef8ad6b383fc489ef99401e7ca0"
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
