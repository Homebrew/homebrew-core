class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.readthedocs.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/2.0.2.tar.gz"
  sha256 "74125750452c751ec62966d0bea8646b2f8d883095892d3dad641ff65df6bf9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9a8a26d50fdc9820edcc65c0a7ac24b9eeac3849c74473a4e394a70c5408bd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9a8a26d50fdc9820edcc65c0a7ac24b9eeac3849c74473a4e394a70c5408bd4"
    sha256 cellar: :any_skip_relocation, monterey:       "d24c807627792ed952b4577bccbdded4f0229d600fed97f11e565abd986d8916"
    sha256 cellar: :any_skip_relocation, big_sur:        "d24c807627792ed952b4577bccbdded4f0229d600fed97f11e565abd986d8916"
    sha256 cellar: :any_skip_relocation, catalina:       "d24c807627792ed952b4577bccbdded4f0229d600fed97f11e565abd986d8916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "429c103dc30811b54b33171b2a1cb9bba47b1f99efe1d878161a424da8d83ae9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}-homebrew")
  end

  def caveats
    <<~EOS
      ===== UPGRADING FROM 1.x TO 2.x =====

      If you are upgrading from ahoy 1.x, note that you'll
      need to upgrade your ahoyapi settings in your .ahoy.yml
      files to 'v2' instead of 'v1'.

      See other changes at:

      https://github.com/ahoy-cli/ahoy

    EOS
  end

  test do
    (testpath/".ahoy.yml").write <<~EOS
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    EOS
    assert_equal "Hello Homebrew!\n", `#{bin}/ahoy hello`

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
