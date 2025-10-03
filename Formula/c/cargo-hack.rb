class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.39.tar.gz"
  sha256 "88ceb040dc3d82ef1f56cd398189240d3922a4ae711a338c5c4ecd52976956a8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c806073573b84297a74fe131e3f506e419955ce023314c39ba9bac15ef097deb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f72e9abb25f9ff2cc8b386a981004e178d0ce06c4715a3210d2c53508c3f481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee9735e497e3f634a40a27ed4cdd10916c18ce448adf970957b8279045958a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bafbec0826e9fdc7db8bb93b36ce0195672fd070bc01561f3aed46f1767347d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8f3590a9b38593d836f9d05e4010ef2435f68a3255be5f9a4d923b4bb83297d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7c568558a74ab119eff9121234e7ce6d09103167824a4071d981b3f690f0c1e"
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

    system "cargo", "new", "hello_world"
    cd "hello_world" do
      assert_match "Finished `dev` profile [unoptimized + debuginfo]", shell_output("cargo hack check 2>&1")
    end
  end
end
