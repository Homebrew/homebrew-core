class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.121.tar.gz"
  sha256 "99d61908f3e2364b31e82e9fb781c80044d26cbfdb2386ab8640205f3b535325"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f4139f4c27426889430a11fe35e5472ed5d0b6c28d74165f791ad5edd82ba2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539e0e3c5c6ad1b6a8b273a501c7cb1bdb20b178aceae5b2014bb771d2f5e796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4f215902b635d4562af8fe5d25a7a8205de154b10504d207e8439d5d53c15b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a85596b5dc6a518f612ef25a33bdbba81e312040fa79fb3ff5ac1fb412092ace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a6c0f2d93b324bff5723e662f358285d5ff256e5572dbd3acd9268d7397f681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6ca0b032a90bbdef8df0895b9558359e22f4bd9eadb625e092370a804e173a6"
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
