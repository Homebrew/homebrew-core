class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.44.tar.gz"
  sha256 "63dd630915e31995899291d602c49a5cfae062af619e1a75ec04e53687552d04"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22fcc1e849186d4c3716650fca9a7ed2283e5b9718814051b180d258615942b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56c3be7d257d7d32390db110afac2571d7283ef95742fe9c87b5ae0b824a07a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a5f9b1de98c01bfc84eec7b0ba141691a4e7e21dbf6b4e90309dfdc0a7b59a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "353c88c1c4988a0f0be55600a7125a4ed982640a68cb02572cf6694b53868ee3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1d1622968f4cae78f4444d45695744a3e6cd7abadf412be9a544e36a2a062b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bfbf0b389ffcfe4d1b18f2e43404176a28413021cf75db0decf54f61d15815d"
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
