class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.2.7.tar.gz"
  sha256 "057031270b4d0ab0be42831614ce45b96c3fc779d201950da7ababf922625391"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1267bb2b2a5f63b362856ce5d26e7f4ae8b51ffbd0725997327d8d75874a357c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1267bb2b2a5f63b362856ce5d26e7f4ae8b51ffbd0725997327d8d75874a357c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1267bb2b2a5f63b362856ce5d26e7f4ae8b51ffbd0725997327d8d75874a357c"
    sha256 cellar: :any_skip_relocation, ventura:        "4f52f7f57bfe8a87be489c0fe5c1d251db81abac6e97a1621290e6e0605cee22"
    sha256 cellar: :any_skip_relocation, monterey:       "4f52f7f57bfe8a87be489c0fe5c1d251db81abac6e97a1621290e6e0605cee22"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f52f7f57bfe8a87be489c0fe5c1d251db81abac6e97a1621290e6e0605cee22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36670ed8949456d6d2455e9655625cee23363d5b97565312b00a686b0ed86ad6"
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
