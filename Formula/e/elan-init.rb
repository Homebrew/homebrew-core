class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "4d38c12f11a9ceb9f7a878376cc525d1491cc41267ec99282be7452c95c30914"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "f7ea437a39ec5eede12d0977de718d723a05aa77962b4e86139c7e9ee688b209"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56825e5f546d2aba77cf47b6fbb8fe59b2458abc42de950981c7d3d18002a6b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "124a5c156152816c3e3b4bb7b5215f1d9aa492d073124bba2ab5eb9da224de12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4efdf0261a3ff73655fc5f63698638bce746403b67022293b0dd471c5576879e"
    sha256 cellar: :any,                 arm64_linux:       "468d9e2fd3c72c64e664d282c78709a9e4829be1201db5d64ed8ec62b49be837"
    sha256 cellar: :any,                 x86_64_linux:      "34356a635d412718a7f016f53dc4026c2a81078bfa7678bcafa51aa9e5341537"
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
