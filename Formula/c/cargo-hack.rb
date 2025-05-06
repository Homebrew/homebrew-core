class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.36.tar.gz"
  sha256 "c3784af50b23a663bc3ac9afe65171125fce9d4931e69fd5ba10baf76fa49068"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4bd553ea805fb772f3aa506811760f5a15e7acf5b87a9cd39d1fdf8c56c34fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e97b220b791be3cea8ec86801bf6db1b678e6c5d148cacd576aede989e58f612"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c88cd8ad026b6e2bd690d82a147bf23ea074a88cd8ff25fd7df8a303a8dec1d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "06592c25f6e885999c3090091141b72b19eaa828784f3c6cc1e892824e1847b3"
    sha256 cellar: :any_skip_relocation, ventura:       "6ed0eb2501acfa6b52fa08e11f03bb5111105fe31086a2dc3c8cf3c3c55cf8e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff05b215de8c94c0b5cc88b0a23a36fe3b458a82c85b9ff6d862c1562925a7b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a092965a4541f529dd573b6e5f4f5ec0770c656660b5cfdb196deabae800ab7"
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
