class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.122.tar.gz"
  sha256 "fc1788db7096de68c9b57fee9b54fd7c053ca4e080555b4dc49a6690d1d03abe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f44915eaa6e506a936ae4cd4dacdc09cc6d1879be61a4540fa4bbd443afc445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf71b52550bc357daac762226d79bc7c51b986c2131bc02b50bd672e56323602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72d816e5331d974169bb386f07ad5927561c3517f666c27e14484f1d2678df54"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e887716e6227bf3dd0c3deb8a370a65707ffbe92db864cb0a334d18867b20bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46ed81dc72436a1c659b62379549aa37a2446aac9f5a9a82451f5263a3154b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b82d126a60285a7433c3255b2386de2151534e1731694cc1c3aa7c767754e5"
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
