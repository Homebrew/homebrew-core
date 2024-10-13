class Goku < Formula
  desc "HTTP load testing tool"
  homepage "https://github.com/jcaromiq/goku"
  url "https://github.com/jcaromiq/goku/archive/refs/tags/1.1.6.tar.gz"
  sha256 "c98e99975942d52932bb1b141aa19390183594793ac38c9db7b1871b06bd24c7"
  license "MIT"
  head "https://github.com/jcaromiq/goku.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a04bc1290d6dd2b2baf2671dbb69ceb987a88a4da824f934581712211c55905c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7bb38283de96e1d4e681dec013a4c17de58bb2d8497e37719da6e899f3be65b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "754d0ad5f8170f0d76799ec01169c7aa7dabec557bf5d0e8c6d902d91a832249"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f1691c720eddede58e6f245171d5ec83cab07688a5cad90a52fbd0e6214a2f1"
    sha256 cellar: :any_skip_relocation, ventura:       "04873b3325ce58762ba03e8c048dc6040c8cb27b4964cc81a3b85da41573db3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b27fd63cbfbfb9febbcabd5526abbdd181f4fa0eee853781dc90c02d3d96705"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/goku --target https://httpbin.org/get")
    assert_match "kamehameha to https://httpbin.org/get with 1 concurrent clients and 1 total iterations", output

    assert_match version.to_s, shell_output("#{bin}/goku --version")
  end
end
