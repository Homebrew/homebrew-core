class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "a298124a295db27015eb95cf0d14508db8d65881a61fca88f311fcbc1591ab41"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d91f2966fea4e0efc01e4455ba15da4fca2cc0f18a7fda9d52ed7a17507edc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32a6dd1757e58c9a20598b26581631de8c9a7481bb90c87f8e848e2f9043d668"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b6c410c775ad8f6e6de61bd1ad568d8f87dfd74375c8c75fc20e4f7af53979e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d46d3872dc33e518ab539e425a0631ffad862c0ffbbf789dada132ceb32d52"
    sha256 cellar: :any_skip_relocation, ventura:       "a3f699516bedf22f21281c43962127218a8c781b95dbe0ca3ee79fa643ec5007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "172fe284a75dc9baf4119fc60fbf1064e5005102ff1bb7720157b0f2508b4d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edca8e454e1af9e1db99897de3545e371b0c1c5c129c8f61469a850d6d53087c"
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
