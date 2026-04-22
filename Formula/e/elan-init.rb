class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "637cf1d0746d05979ec9f97f577ac57f38f1606fc5c596d10579b9b367a3157d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aa3a85a551759132834cafd244eabdc65d9f35bdcfb769367e20eeddd0a94ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6227c7aecf02311c895a073da058c6b3e3bdcef838e5d8388e7fd83ed0af8b1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46647e6a334a182e45624b61624b6c775efbdefe5e75cabc801f6673d2c6b278"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f3638369e2d18a4c0b319d88acf822ed8c1e846192141783b4d131be09e4f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde639ce235924aee6b5714aaf28e037f9a18f7fe3e41e4554bcc074dc8b188f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0e4b69d9f53afd63c0e62acda5e7fef1f821eee0ecf40b754c6997f0bc97e9f"
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
