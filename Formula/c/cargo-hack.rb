class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.43.tar.gz"
  sha256 "cf9048b4b5e52a14cd80d226c68a9a8ee874e187bad31f92c253aba795cc13d4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e93226d97dbdb77670fdf193b90a45eef3cfb32f7ee702113faf5dc7b7da05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c836a65fdbfa2d76cc05605b9f15afd835f9f4a1cd6a306d3b446d3458d1ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2b746e3e5ff1c92b567a60bdd727704be9dacbf13e54054f7e9e382694faa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea35e0efc48f3f8956584be96cda1de92a712b7a7d13763df6885816e7b5fabe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c49415361a066b378e8958ebffe6a6e2b1bccba86401ebaf64b03ac160127b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0733e1d9ab659eb1c7386b1f36c485233cc2eed48ba15ec1487b8b763fb9daa8"
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
