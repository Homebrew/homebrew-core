class ForgejoCli < Formula
  desc "CLI tool for interacting with Forgejo"
  homepage "https://codeberg.org/forgejo-contrib/forgejo-cli"
  url "https://codeberg.org/forgejo-contrib/forgejo-cli/archive/v0.3.0.tar.gz"
  sha256 "12d39d3e26a7ee572ae75d9db1faa9367de5af0e849d9cca24b77cb870142751"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://codeberg.org/forgejo-contrib/forgejo-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34a8d50ac5226006b6e236440d52f6822cdbd7ddc57b073f676655ecef4b4efb"
    sha256 cellar: :any,                 arm64_sequoia: "26ecba9bb5c54bef4b13ed743f6a43c2f9e4f1ecfe337d7cc55d9addde8dfe28"
    sha256 cellar: :any,                 arm64_sonoma:  "c494757ae9acb634899888f46286a9beb820f065e959d43ce379bb6fc85bab9d"
    sha256 cellar: :any,                 sonoma:        "1e1470d0dd201bf6d03a5e89994718575340059ec4c840bba0c99483d6f0f540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14ad45180433146f94e617cc5cc532a2282bfe88cfb2b9644b21f0b802be7570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e4d59c45352f47fde1ff63657e159c980b987e6eba3a88c9dddaf6c5c489f07"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fj", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fj version")

    assert_match "Beyond coding. We forge.", shell_output("#{bin}/fj repo view codeberg.org/forgejo/forgejo")
  end
end
