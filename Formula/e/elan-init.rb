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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "083ef770ce252675d822db9f15c38de78978e94f25d619f5367218f061dcdaba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f51d6f80b575b8b8762b5ba004d046549a4408bc2e3949b1fed9158528871f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb4ddcb8c905dbc6c7cb56b04465338959c25742c5b641a0139578f230ea795a"
    sha256 cellar: :any,                 arm64_linux:       "54c49e48f98e30fb5afe6ce09e83dafbf07beeb6e0d48be2d74dcf7587897793"
    sha256 cellar: :any,                 x86_64_linux:      "f903fe68cd15f611d2b46ed70fe4c077b381f75d171abc634f237711dfd29096"
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
