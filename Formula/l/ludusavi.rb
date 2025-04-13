class Ludusavi < Formula
  desc "Backup tool for PC game saves"
  homepage "https://github.com/mtkennerly/ludusavi"
  url "https://github.com/mtkennerly/ludusavi/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "dacff74da8ee67d30984df4adcff82b5ad625d3b001d5b4b68b2bbcc2553edcb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4b66cbff39ea94de07d1f5aefa056ff1e739f5079e44a0cbaca238cb51e3291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d241ecfd18b7ecf7af38a92d42a8591aa91ca39458c28b0b73998b17e77bc9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cafc67c83e52327139a5a5438477e7893903cb5c4f5fda787568bc996d1e6de"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e209367bb9a7866f52623cb25a56aedf3f10197383185c0cff4640ed9110afa"
    sha256 cellar: :any_skip_relocation, ventura:       "9065e96588a5244eb64a4ad614d253cf367b45c7b63a6bd0e329e81daddf767a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d91fe8a2513748e099ccdcb8db391a18fd34d7c0f1db999a37453f9cd2004d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4738b3e1d96965d1ae32f811247621efd2135557411a261e6962d00eb9af185"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ludusavi -V")
    assert_empty shell_output("#{bin}/ludusavi backups").strip
  end
end
