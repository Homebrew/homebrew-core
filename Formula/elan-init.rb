class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.4.6.tar.gz"
  sha256 "0f8c736f67071e7b680d0b7e57e1c614696824c6ecc8e636aea47ba26b72f523"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8066f6c26df8bb1667c43453a06e1411e804c8ee7111a6ed660d06809c579957"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7772e04a1395d2a2a95d79f36fb20a18ebc5e712ce66033e2357ea7f141bc95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3ac9269b640d9eefb55ae14cfb5a128b0cf1d2e912fd134c4e8b083cc192b27"
    sha256 cellar: :any_skip_relocation, ventura:        "e621f34cae570966f7cb333e35179e11a24308452f8094bcfefd10ecf650573c"
    sha256 cellar: :any_skip_relocation, monterey:       "2911b958d78383c0c9aedc2e1b0c5ec96f15c4d0c5b357c967017228df69dd20"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea7d7706ab8471852799fcba42a513855ac3a3af92f1e24a54e9af81edb3d332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0812dd452c4fbf791e3e6f1cd5a7e1dc5aa4d5049ee7bf598dbc29837f0fab9"
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
