class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "a4a99e2aafca4ce316ef8f88757fafbbf50d2a5912551086c5aaa522c9d976f4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71de04c8408f37e34aab966a7b6d1439a81e4233d82c0ea4cd5cca8f57bb45e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70553de5241801a2e59c10c5a0304c68d365939f881448db83686a84ee6d2622"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c5a97ac6e90f7f41b7aecf11d1ff1cbf6fcd6f5c4174e5e39947e4a642829da"
    sha256 cellar: :any_skip_relocation, sonoma:        "bed5a10adf475346b7cf8be6bf8c314ce136aaacbf938c9a2da4f77b56b3d9a4"
    sha256 cellar: :any_skip_relocation, ventura:       "53256d38860f897809c90deffc2a06f3329f0f44b9eaa0c556e5cf8de3e75af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e00621364800d7384ee4e7a49a2ca120e62e8f30358106e374cac4ab11aa4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1121213571c65b066dae69a6a228aa259bb0afbda3d56502464b19f4b29bde8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "lean-cli", because: "both install `lean` binaries"
  conflicts_with "lean", because: "`lean` and `elan-init` install the same binaries"

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
