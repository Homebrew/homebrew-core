class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.124.tar.gz"
  sha256 "c357f3b6fb485c4959ba4e70ae8369f129d902b32b5732c6f4048fc2fd286c64"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feae343c99fdd35bbf63e59c69faf05dda5ff1fcf65e5c90ab6f7542839e9474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ab870f943978c31661a9d0d0613062d6355728ab6e497923fa735cd8e71007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6ffa68b9fb0de5e3d7d22e0e6c34414281359fb4971249f62785be7298ba6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd59a61ab96544039d87cd28d59794bbf725ca5e9204cb82744ed870971ee8df"
    sha256 cellar: :any,                 arm64_linux:   "f9f219b3270b1541e089baa519efd3c0126105454f9bf1231408d6ff6df1414f"
    sha256 cellar: :any,                 x86_64_linux:  "1bb8222bc8a9d1be8d6ea0d303388d5815404c93981bfbbaa85f257eb68737ff"
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
