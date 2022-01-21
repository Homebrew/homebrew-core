class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.5.29.tar.gz"
  sha256 "4dc02d9e7ecddf7364b1862d8b478c2a6f01e0eea9dd755e40e171c42d0b3511"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca0f2e8e6e98e45f0dd9647d7581c6f0b5cabca77576b39e895f4e62a4705db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4f9c40b4fc2fc599e3fcef9b584080a80fdf0b71614c0b1281a02b61fb3c9eb"
    sha256 cellar: :any_skip_relocation, monterey:       "b68cf73a6963151c99cc5510fe0ce54a3a68aa40d2b6ded789f0b3a1e27b545f"
    sha256 cellar: :any_skip_relocation, big_sur:        "794caa4602c36b66823fb2026ffb235b78ddd7dadda9ed170686de31b896ee00"
    sha256 cellar: :any_skip_relocation, catalina:       "df949186d6c8448d6296230f4dff2f7ba1cd80e8638b9dafc4b4cb3f6b563420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3557bbacc945d70f86b497de9054f2bc6fc2fb0db121d00b40cabbceb6431efd"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
