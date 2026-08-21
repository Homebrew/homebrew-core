class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.126.tar.gz"
  sha256 "ee878b56a01a34deca5ac616bbc553859020e26b0d139570819fda788832d157"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e74205d40dad6bc1cfdfefd77d6c683b569fbffee3844b03331a71cd8b162188"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae40757085c6609594349e5cfa4ef5edddcd9365f214567bc372f94ad096eb3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca85d75947e125a4ca6623623638ef97277f45ea1733ab7b2bbccf1844d0bfbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c204112c30f3c80152a6a08c6619d3075ebb12fcb4378bdb4befb295caeed036"
    sha256 cellar: :any,                 arm64_linux:   "5d3a7ba37d70101e32390f75afeb22216d620426d55d05d25fb4b120e146bc64"
    sha256 cellar: :any,                 x86_64_linux:  "9763cbff28c3517bb02c37712a1a1fa7c8661292a128185a1260a73518d6ce94"
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
