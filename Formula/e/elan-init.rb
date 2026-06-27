class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "7094a5063378225598a420b13eded60f58c21f49fc2e009c68a6506da5d62580"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d56c9a2feed740f0eb61e5e45c18f350057649ab70904a0639ce621864c40bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95c6059bf4969b891585eab9d96b179d4ca2e2d3f08fe6f0f8531cf55fece429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "303a5825d263d9348a699aa3d3b1f1a6fb6ba8f73a12bcf1d1397385aaf2e4f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eab0dffe139cc8316551030634f0ca89dd743e3eabe825e9b9237d2064d5b4b"
    sha256 cellar: :any,                 arm64_linux:   "9b5f98d89886f0beff1eb92baaf3ef2a3f9c79befe8ba996ab4e1b0d1ef1d9f9"
    sha256 cellar: :any,                 x86_64_linux:  "f2f6c3b396202085ab6e7eb4b95b8a7cdc4b87bb15d81fee436e11c653c1f177"
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
