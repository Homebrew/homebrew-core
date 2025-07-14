class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.37.tar.gz"
  sha256 "16c183bedc4e72669b9949b7fe7ceca2d401a68b0c19bc2d8d91dba03c0cba35"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8032b57a0c726b1835c9c013068a0fcdeed2fef09954d5da6f0617c3c412a50c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46f02e0cd1fb22298a9103bddac7b015f378b63d34fdf88c5dfbb0b0956b6fa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02dc84124809841fcfa986da42105b9150212257ed25377e2bd0aff28658ce9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "80b02f8bc557f6c4afdc138429c6106bbfe9b3aac96a4caaa30dd30f84a233f0"
    sha256 cellar: :any_skip_relocation, ventura:       "60579f056b740a62ff406b186890634cae24ab2991e068c6258f6bc52d6d025c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a1ce77beccf516e48dc619a82b5bdc73ad10e955785e2832855e488aa9def22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afcf04941dc5c68008012b57d5642c2fac9e9bc4fe7def11d292382bc81c59a2"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world"
    cd "hello_world" do
      assert_match "Finished `dev` profile [unoptimized + debuginfo]", shell_output("cargo hack check 2>&1")
    end
  end
end
