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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5b7ecc6769afb1462a348a86983ae864d1ec990b2f7f7a8d2254a608ab17170"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7284664746c1d9c96bdcb2eb0d0a530afb3a9140f799ab75ca42c647df50f204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8863f82f766e102c48fabd329d0d0ee30f0c4c6af7e7d4d0415ca946682c56f5"
    sha256 cellar: :any,                 arm64_linux:       "1c417f4e363503715f9d28742b6b5892f8be0776064e8e5482facb84d2610a09"
    sha256 cellar: :any,                 x86_64_linux:      "31d10a1966ca8a4550baf61a80c0e2ddb1be9a3453dc1a6d92f462c7a57d2d33"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"
  depends_on "openssl@4"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "xz"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "lean-cli", because: "both install `lean` binaries"

  # openssl@4 support
  patch do
    url "https://github.com/leanprover/elan/commit/5a90cb8529f1c96105cd7f67e3080781a52bac45.patch?full_index=1"
    sha256 "c2a7087cc30d2481de7c6ae14fbd43189b9a7f7048a16cdc4059d9aa289a0bbe"
    type :unofficial
    resolves "https://github.com/leanprover/elan/pull/213"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
