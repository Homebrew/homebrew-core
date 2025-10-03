class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "822a360262df27a288f38ef04ab1ceb8e32fff2c907dc4a3bbc3e1c7dd3d0467"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9cbf4acbe7381da8e026679e6c316dc42eb1fc124cba4e2fc46650b4846e636"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f2fbc2936d4dad3a8732437b413c29fb7405efcfa201a69f41617f037360f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7849dce2fcb20ca1d0c01864c015801af53ca342b4835c5d1f3026dcfac49cca"
    sha256 cellar: :any_skip_relocation, sonoma:        "de48399dd9706be66f7d9e27c4d1f755130eb442ca10b3b348620f69c4005d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fdc136512f71e120dac7be080a2511b5152af7173aaa3f256e26c2b47603416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5768dd564b60e0d8bb527b2734d901c910e4f04d06db87d083541b722be1dda0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
