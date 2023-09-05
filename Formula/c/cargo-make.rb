class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.13.tar.gz"
  sha256 "a5a530221bee15d7d72a4ee092970e660a8344e29118d476c178fce05e42e622"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "beed9a9e8de4de3142f1d38fd9ab1bd13d9e12b5258ce915ed050268b071079a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ba0c5eca30929b38732e85e005a157d1cc575483bc26c59d824aa3f22b5aa65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00f24e1cc92d8df3ca1f005d46a93994d2b06a50724f935c31d2b4a9851affd1"
    sha256 cellar: :any_skip_relocation, ventura:        "dd04a2b82d8a1bbd7b8d97650464c63158b305a3d76713fa66c58bbe27a4de8b"
    sha256 cellar: :any_skip_relocation, monterey:       "63727d6d3e1b2b23731472854988dc65da87e5f0368bb6c4722008cc9288f453"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b51822b6ccf2d873374ccb8e48d73da0ce37ab87f7e8d06d5aae325c33c42a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b49450412e66d920b4db1734ea72335ba6cc4a8eba762981d0163acdffa4c18"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end
