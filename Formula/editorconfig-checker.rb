class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/2.7.0.tar.gz"
  sha256 "6f7f842e04117c0124638973e0f0f49d669daa6e6dcec7e0ecf86109b2c51e99"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c3ff8bba72c42bc77d381d3273b2219f4bb060f14c826bad8e2a6c054e1ceae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c3ff8bba72c42bc77d381d3273b2219f4bb060f14c826bad8e2a6c054e1ceae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c3ff8bba72c42bc77d381d3273b2219f4bb060f14c826bad8e2a6c054e1ceae"
    sha256 cellar: :any_skip_relocation, ventura:        "34872cd61b879386460265318386355db50e30002cd2c3ab81c632485cf25bd9"
    sha256 cellar: :any_skip_relocation, monterey:       "34872cd61b879386460265318386355db50e30002cd2c3ab81c632485cf25bd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "34872cd61b879386460265318386355db50e30002cd2c3ab81c632485cf25bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcdae0ba7faf0330f8f46663b72e15aedcacaa4bfaac97252e574c1909c9109a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"
    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
