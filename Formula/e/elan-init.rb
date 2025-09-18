class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "7d31b3d1d69857b11611363bd94bfdc4f0525a85077f20f823abf65b39ccc350"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61ef80b2085b384cd60d93316b4739c4de6d218e374ea603b1b6d1dc66dd2a50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4902a5f8381b8b51b1bd53bf09e9547795d327c16292cbd5cea895a232bff0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "244c72110dc59e51a7b8248b82ce1773277cc3c61f45ca5ed1bfd49d2af58b25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36c1f08f1df2453875145833443e4666498b85d02e194b3c1ad5c6bf9401cd31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac4eb727726c26fe57df0136286bd192cdeea784f19dea1975b111721a4dbe26"
    sha256 cellar: :any_skip_relocation, ventura:       "1a334d939336097ded29ac2578ac4d4813a97097f815d9bcfa4870b5923536b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36c8e9b09da80ed74aaf314080958e8d1d03615aa6306ab1b9d898e45fd9f812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af3db622b0392ebdda14742c19a9830c656336614c3c8036d2bde87ebe44c273"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "lean-cli", because: "both install `lean` binaries"

  def install
    ENV["RELEASE_TARGET_NAME"] = "homebrew-build"

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args

    %w[lean leanpkg leanchecker leanc leanmake lake elan].each do |link|
      bin.install_symlink "elan-init" => link
    end

    generate_completions_from_executable(bin/"elan", "completions")
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
