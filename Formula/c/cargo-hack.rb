class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.45.tar.gz"
  sha256 "b7b921beacdbb815dc89a04024f48f1b1735daef890d2398e04f27f006c1d38e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e50f3c181e6f16ada390245c44f98e5a144054641d204af6a58f1014a3e24e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "837e30bbc7b1a77cbe4310087aa941565ccd8de3f254e3118fff947560034221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6183f8ce8db9f71975f5083f30e4091f91aebd39cd1b70df67891684e95f09f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f538aed8e5fa35d18617ddffb1038ba985c1302da7f2382da660b807545f486"
    sha256 cellar: :any,                 arm64_linux:   "8d91afc015d47a8765077ec2f0e896ca995804522ad1986dc1214e9fdeebca81"
    sha256 cellar: :any,                 x86_64_linux:  "2036d4b41c6932d54e701c28d7069c67ada44c8aa6bdf8d6a56ea571ae8f529e"
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
