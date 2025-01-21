class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.100.tar.gz"
  sha256 "220e917017d91822c92f58238bef01ce2dc525c47c6815cd081569c0e5038416"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b08c6b77e75d43457e961174a7d01f5b50e1a126c63054338d1522b68ab55127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a23cbdf8b5f96037639f99c0406eb5a7fce4c2d85d68a3eb31247d89ddc76a1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e16b50359c95b574d78c4899075d8687c5e9b6f86be86648f590849af911d9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b72b10a6726abe1690fb27d4b38b090a582f8596a087febaf07d34f8c4a7cb4"
    sha256 cellar: :any_skip_relocation, ventura:       "a8c206ea519a2611e7bb003f300c2ba352dff9d3a09553be2ec0f2d024424b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292d1d91d2bb576668dfcb2346d0480aff2047054445fd2b9674af9e4367254b"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end
