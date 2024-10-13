class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "b31befe0df562c5626c52d1cef70d272115054fa707debe56ade9e4f2f28a956"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48b3493b2ef8b41ae98b823b759ce8d282994899c8c3d9cac066c80b1bfc05d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9f40c7b2fd01a37f515018006ef7cba9f639eb5f5e55659318b5f17e8df19ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "527dfdf3b7769259c507b60e519779eb0818ceadbfe78cbd8e0abadefc92f0ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "6842a139f8597c9f5520304ba372fae3f2a3aa2a18f5502d9544ccefb7b02d55"
    sha256 cellar: :any_skip_relocation, ventura:       "273ed1e79298d9e0f02a07d86a9d756073ec7362728f4fb7e717b4aa6e32fe34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa4748015813df022131377c59bb657f9ff66c327230e25a471031ed6ff6ea5"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
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
