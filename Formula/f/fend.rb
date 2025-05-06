class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "59073829d4963ce7c893bf805ec35986d10b90674dcfd67e2e74ebc043212594"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb2c9edbc9b6034771b1f25543358f766a0e924e052b1cfeac4a25727ccee321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f995d29d428befcf117b5be0d6a337b07c96c7d047dd2f60b7739b0f8c7ee59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "271a6f570e6ec40b06c12cb6f2dbcf1e01961536987c0452072a19f26762fbd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "dacd98981654283ab774d6b8416fa89e4fdb6bb295b6c3b96f261dc139e160aa"
    sha256 cellar: :any_skip_relocation, ventura:       "862a1e66943aba47eeff5fe1fd0f40a81274a65257f5e96e2cd241a5fa34ebd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "396045a07977865d85345b0dc48d1a68423ab136c72659d36b39029cf71d9877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c81f0535e457eacdccce74da78ffffad71b71ead698172b7d0d1696100d6a2e9"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
