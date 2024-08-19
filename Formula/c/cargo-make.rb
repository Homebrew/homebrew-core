class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.15.tar.gz"
  sha256 "fb4d2937f5d32ba42f670888048ad6400788fe2b6e8e2487c06a11d4bc4d22ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffb5c4bce5f01bbe19675d983ea1ffa198b3d104dc57d11ab1dd7fc76b40c7a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b814637ad39693d41677d8e7c01b00c15926c1fb95027a11133da7a010c8bb25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02208befc96a6271b89a9b4bd6c90da32a86e8cd1bc621ce462d455a6e23812d"
    sha256 cellar: :any_skip_relocation, sonoma:         "36a4528b40b6054513efacda73f0022c0aaa1e27b6c4392769ec5c004e86b3a9"
    sha256 cellar: :any_skip_relocation, ventura:        "ef347535138fd144828eb457a228250a11e430080c7f2119826fa47a449499cb"
    sha256 cellar: :any_skip_relocation, monterey:       "2a0a857524ffaf9e1f77278def30db88349b4e57b5f7039973feea4858454084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183b82d9e31a56b22a26c0f9a726a89abf5c2056a62edd5f8fa54816ae161f74"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
