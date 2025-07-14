class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.113.tar.gz"
  sha256 "8d2571214b19cb47a9068ad2e81ae819a04798f5c7508fae6d51ada052bda5d0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "434e3a2abdc27e4b5e917ae77a0152e614f9f5736b5c06c7974ccb53f075ab30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a84d97b7d7f074539885bfadf911459e0e72260f03106e5ffd618eaecc9ad7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eab6c80aef652aff8787df173d1ab13ecc493d3cedbceb19db05bca217b7384e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6dedc5f386e5e2ffe622c79e2dcbc246eb2b3ad48a7e56d6588f12501b8d86"
    sha256 cellar: :any_skip_relocation, ventura:       "d261c3273d43813cc78103c9b8cfa8c2cd93fae6d71012785482e2ca67fedf2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9bdef308e70f41931658770044928c0a7b24e1ecffc2b28cc1471b6ad5fba9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3432b8995a58765dc442a370ef6c883e82723d97c8c292830caff883e7158f1f"
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
