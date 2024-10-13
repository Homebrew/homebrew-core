class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.37.22.tar.gz"
  sha256 "961492f6985a3a1d86f29f8ca92ecd1e81e81f7d2878a3ea53132bf95c3b3d07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9badf56a37f3c157e1029ef3c537ebefcf8c8b40ea9429e7a4b8077596f4a03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21180129b79408adba314ed3d948363bc07403729e16f756b67b05948e1a27be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a2408eef702fef138921d173da2a3e26854be12c17a05f0fd084a44ee6710dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d03657f55ab3ba1596d3564941e1abea4ca0ce9d97a57576effcf1b124930f"
    sha256 cellar: :any_skip_relocation, ventura:       "fe658ddc127849400b32f527a9c113b2037e0805d07dff04d4f8b7e7bcd45871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c3506068ab93c3df30f95928e628a597cd67862ea71fd4214adbca822fed1cf"
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
