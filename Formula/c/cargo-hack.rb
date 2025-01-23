class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.34.tar.gz"
  sha256 "68315c0370ce9794ba44f18e586e1f6491c63615c0423e052d61833cfb96116c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60613cd95e5c2388c2ff5e13d7c0f8e3cb2b4aa68e203d43dc57b40abaf771d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7ed278647611bd5c24ee4115700a9a9b6b744dd8dc0b61a05573a136e8644a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "464e8a608dff8a4023f52da4e07cd02ba6fb48d6a5ea4da858037a16e9e22e24"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc9f3516ce1f1a6bc7ef84b1a6467c4d1eee318bf21743085a7916f0c7981c7"
    sha256 cellar: :any_skip_relocation, ventura:       "1eca8e81bb200116decb382baca39ba9278b08c454e6c193f44b4e7a6c479a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f17328e255bfcf531ce3119bea9e3ba07014be6a2d4f4475f9b470a48ef3b0c"
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

    system "cargo", "new", "hello_world"
    cd "hello_world" do
      assert_match "Finished `dev` profile [unoptimized + debuginfo]", shell_output("cargo hack check 2>&1")
    end
  end
end
