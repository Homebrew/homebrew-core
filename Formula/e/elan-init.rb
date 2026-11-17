class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "57c593002382a5356abe1dd5c37edbd2231e60202b34584ed33fa79979677418"
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
