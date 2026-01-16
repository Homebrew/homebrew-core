class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.119.tar.gz"
  sha256 "c4b2c38dd157ce8eeb81ee1762b0a235ed23d2300fdb29a73c54313a927b0262"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edf4e8b9e99bdbdea745dd5ede756debf8984ccf0dd61071ef6d81b7140950c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "363b9b225b848bb67b5b111c834cbd42e0408d4c8bb390913dd2bd69084a5989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a6260c40dbe842fa826bedede2da7a344f171306b8a2829a37119dcb38097e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c9b272c580e62e6438fd39043703709d0f84554111b79e4d32467dc3bc9ad00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d85452155ab6c0b1549a0705b198c330c9d5cf0054296359c6c3f344d7665814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb6b38bdf57f68ab2ad2897db12473d31e8714d226a34b528fa2f21cc138ce28"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end
