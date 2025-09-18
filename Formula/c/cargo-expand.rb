class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.116.tar.gz"
  sha256 "4cac32b6e7742f74a9c2387e85a81d550787dfe7aa4e981e0862e748205e6395"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3c070ada8abce6d79f10316d11daf593cfb0aea72ad5a79891799ec5450487a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f1297bd6c41979bef12d675a6265024c737a6647297f36dd7ba80a613e6a3c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "960864037efc716679dd0857fdc353e7f0f21992d77265ce63edf947193c330a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "583c5977cd6d0e1848e91fdb7dd485a248e5dd4b4d38b101bd9187ef2c6401a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1adc76395386f1ec030c9f3fe9bb466fd1928fca4d107cd4a64ec44eae1997dc"
    sha256 cellar: :any_skip_relocation, ventura:       "d3aec6e933e3cb36aa9fac9980aa990ad9e2f5acbc940d756c345e9104df3f72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2782e414cae28fee4df40a523deb40812e4cebcf3144d0a7effb657b8669b1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b24e2ba5c84b71a42d2f9ba8f35eed187773ccc27d3d561d3d6a157952da1f77"
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
