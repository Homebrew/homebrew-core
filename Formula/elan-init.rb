class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.4.5.tar.gz"
  sha256 "048f3a6f85ce84870b68ddd8a6f3a4216aab04ef904df36c178c8f08e20168a8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34009ca3e0f16081acefed8511e23d19ae3c756b1e96ebf07649cad6d7aac859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9be30359788ccc0e097234ab16daaedf8729a475b34761e62ed762c3b6c90da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9079ebd0c10750525cf0321eccfb798622e7da9faa70627237372ff3dffbaa77"
    sha256 cellar: :any_skip_relocation, ventura:        "51df3a4b21d70584b0fba31d51c478f4dd7fcff217dcb1aaf32c278001eb201e"
    sha256 cellar: :any_skip_relocation, monterey:       "7e38f2ffba9fe3fc6dedc5404f39c0fed251ad324b76f575cf2db6de3657aa82"
    sha256 cellar: :any_skip_relocation, big_sur:        "449cbd4e3d21f26e2a4d2f64489d42eeade4b22a2837b05f920054f31782d769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47327987e6c01c871cdb93ef67427d2f45561f09449975d2f341296785fc9546"
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
