class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "2c53922b83b693c852581942ddcf8e02e1bcd691f30c00e8066cdd6ab2070b86"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db21c648244b0a4d53fef9aeb10d7d0dc3b640af0229eb3a986fa58955cf417c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23a873fb4f16bfa2c049f65b7c68d7dc3ac9976a81a4191eec08b2bcd508c3f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81f331397cacc008651ea31bb3a1618a1317eb11e4879cde6655036a86c7f4cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c50f9bac90906163d04042ec31be34db7f24836f410c3a42685afa379d6dd15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5783a60f33bce682339b2fcc8a74c80196895022b3dd0a08b15d678836963a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3643edb40ac0aff3cf9cf5cc6a3733bfa2e5eb562ed959f11e93b7914ee1225"
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
