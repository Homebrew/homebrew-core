class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.4.4.tar.gz"
  sha256 "67cbaa4d2c4558fe88d3b13d75862c57150cf503ce9f4942efbdae10f93ac83f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "864aa2f2c6df8bef797fb39f5c8c0610f4180f81c2044ced7ffc8aa17fb65b2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aa26ca2700a5c83fa5ef2d88354f73d6f93e78f04d4c077a9d813ccfcf06ffb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d057b97202834bb417f16a20e281b4058daa789479e37a44e43c7afef9c8ac4"
    sha256 cellar: :any_skip_relocation, ventura:        "4df1e7a1b6c3f6e30baa020e8a82b7f0c1d405ceb0cee1854047a307717b4267"
    sha256 cellar: :any_skip_relocation, monterey:       "464b79bb5d98aafb2649f39965def30ee7d8898ab59fd5fbd08b044108ba369d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a8c29c06658903cc0f7be6ce3980244d0074eade9bf8f997938420d46e164b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b58ed93a032b09d9e993054a0a40893473bf7a3806764c21d66ee6c5844f717f"
  end

  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "zlib"

  conflicts_with "lean", because: "`lean` and `elan-init` install the same binaries"

  def install
    ENV["RELEASE_TARGET_NAME"] = "homebrew-build"

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args

    %w[lean leanpkg leanchecker leanc leanmake lake elan].each do |link|
      bin.install_symlink "elan-init" => link
    end

    generate_completions_from_executable(bin/"elan", "completions", base_name: "elan")
  end

  test do
    ENV["ELAN_HOME"] = testpath/".elan"

    system bin/"elan-init", "-y", "--default-toolchain=leanprover/lean4:stable"
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree {α : Type} : Type
      | node : α → List tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a := by
          intro h; cases h with
          | intro ha hb => constructor; exact hb; exact ha
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"lake", "help"
  end
end
