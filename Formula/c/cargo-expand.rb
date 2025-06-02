class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.108.tar.gz"
  sha256 "a5c8ed7ac0d17e6778292762807ca328f28b605604d6c5019a59c2f49bd1ec70"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "753627b70952791d2d445f38032ba8569213f2fd0e383694423dab6e146372de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b47dcfc261e1d33a81cdadf56aa98e5cbefed6de6366e1e623eca8ac302c014"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d71e6a04a558ca0388eb0404242869005f21646bfa1c17271987df2d57685f2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce527abd9ad9b83023bb1496f6065a392dc22f3aa99989cdd57c187f368318d7"
    sha256 cellar: :any_skip_relocation, ventura:       "cc7125ad990a83f61f848e49261cf9777d208317e483910c7c9bd45b39f24ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e5031a5ef150a7f157ec4962101c6420558f99fabb97a995602e51cbd9be597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b47652cf030289246087367b29da50b7c7a55608b945369694e0a16ecf4643f3"
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
