class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.2.4.tar.gz"
  sha256 "aae972bd10907763d53d0ea9593c02a340359505ce667b99e5289372f6801eec"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87bf79bf84058beab76f351f5cd5603802728ac926ac07ff87e85af1c36a0aef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9cdeeb614e6fc9a63fa44ef2f420e92ce8423bb7cefbaff08abd2f11fd9992fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41cc13753c10dec5df9d1088e86e3b95c8869f72cb6f6fd19a4768eec91baddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "010bfe7613650c53af524d535cde51b054f367d221b4674481b86c392e4e4127"
    sha256 cellar: :any_skip_relocation, sonoma:            "c38383c2cb74ce37d95cf3d7b2a005d43056052f2bd9efbc84e8ccb7dc751d67"
    sha256 cellar: :any,                 arm64_linux:       "b2b080b38272313a756740c5b71525df1b9ad8faf936606b38c85e64963819cc"
    sha256 cellar: :any,                 x86_64_linux:      "8c19a2ad1d8bd4d26dc278ba38bda3109d437ac11c3fd0e3f2c3dd21f70d86dd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "xz"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "lean-cli", because: "both install `lean` binaries"

  def install
    ENV["RELEASE_TARGET_NAME"] = "homebrew-build"

    system "cargo", "install", *std_cargo_args(features: "no-self-update")

    %w[lean leanpkg leanchecker leanc leanmake lake elan].each do |link|
      bin.install_symlink "elan-init" => link
    end

    generate_completions_from_executable(bin/"elan", "completions")
  end

  test do
    ENV["ELAN_HOME"] = testpath/".elan"

    system bin/"elan-init", "-y", "--default-toolchain=leanprover/lean4:stable"
    (testpath/"hello.lean").write <<~LEAN
      def id' {α : Type} (x : α) : α := x

      inductive tree {α : Type} : Type
      | node : α → List tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a := by
          intro h; cases h with
          | intro ha hb => constructor; exact hb; exact ha
    LEAN
    system bin/"lean", testpath/"hello.lean"
    system bin/"lake", "help"
  end
end
