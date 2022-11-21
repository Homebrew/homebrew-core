class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.4.2.tar.gz"
  sha256 "d15dc93575601224b73c4744c27f28cb118655659b20d444e93ed63ba30b7def"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "d075ba86ef1a1bf8030d50c10ec9e6963ba774d82ed0e0012f5377db76033727"
    sha256 cellar: :any_skip_relocation, monterey:     "a68263b2e47ea890c3494fbab60501d547ca2d7921993828b67ed3fd8deacf37"
    sha256 cellar: :any_skip_relocation, big_sur:      "83b6e3e898f5256f01a55a5b55928d5223c1ae48046526564e3cfc27deb12e70"
    sha256 cellar: :any_skip_relocation, catalina:     "d10145a7f26ff7d328e613092670a59cbf28c1d172c365636c749eaff08238b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d562c8d7257a8d6109c251c7b92f17dccb53fa55317b5c1d1a50d1d235431f1"
  end

  depends_on "rust" => :build
  # elan-init will run on arm64 Macs, but will fetch Leans that are x86_64.
  depends_on arch: :x86_64
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "zlib"

  conflicts_with "lean", because: "`lean` and `elan-init` install the same binaries"

  def install
    ENV["RELEASE_TARGET_NAME"] = "homebrew-build"

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args

    %w[lean leanpkg leanchecker leanc leanmake lake elan].each do |link|
      bin.install_symlink "elan-init" => link
    end

    generate_completions_from_executable(bin/"elan", "completions", base_name: "elan")
  end

  test do
    system bin/"elan-init", "-y"
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"leanpkg", "help"
  end
end
