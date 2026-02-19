class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.24.tar.gz"
  sha256 "a7f6f7332862442e6020e8d8b2568a6fa8eed28156be0dddd61982e1e644cf02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c85317163c83d67bdc08f66186d287ab4ade17702716118c30dffc60300d2416"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19d759576565d7abaf24e1333ae5e52383f998571025a563c7f994df57dd30fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d51b915c4a7eb13107f048b8086be05eac529766f6b61d94238f6de7f95e183c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03378097976272095569b5c44ec8cf5ed5220318ea3c0d03eaa3a4f1d91ce8e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "086c607cd949bf09f50993d4a486137350c6a69df15bcc8bffcde33228aa330c"
    sha256 cellar: :any_skip_relocation, ventura:       "4d4e6df0408ec7ee1110e0380a32c280d1d657b744a302279fdfbc9811a7e8df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a38ee58a40f555beed4820c611cb375ae11ced7c35f294b799434407f2287075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "476ba3af76f954ed24d8cb84e7e57eab3a32b86d51d21f7e219be831264137f5"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    text = "it's working!"
    (testpath/"Makefile.toml").write <<~TOML
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    TOML

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end
