class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.106.tar.gz"
  sha256 "3917f35b54b4186ac5697648a673a70ab58567bebbee926d5d60cbea5f342471"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1446baec0e867d5bf0dcf9297cf0ca4376d31d967b9a7f61ba425f3327e3d44d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3add3bb71dadde1dd3ddf53030876f25c9be442c99539b0413eccb0a6fa0cf9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1ec2ba62a11b75d8cbe4bbac17feb1025e12e2f249ba6949ea27c11cbfb888c"
    sha256 cellar: :any_skip_relocation, sonoma:        "468861d35afd0b0064541cadbc06a7bef61f45fd2f895438125f190eb526cbec"
    sha256 cellar: :any_skip_relocation, ventura:       "3e112c2726e3ef0b76aced248b37a2e439be4d7978d4cece9e0c671af671d400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4e271c5d2e81464db6e4780ea330c2c06ecc0643fcc44ed120bddd6821098ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbea3854e20f659df2d26baa5cd2dc092733b10a89212d0a1485dedfa091fab2"
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
