class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v1.4.2.tar.gz"
  sha256 "d15dc93575601224b73c4744c27f28cb118655659b20d444e93ed63ba30b7def"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "f07f593c8c3668c57cc595792c9ad1178a0949269342902c7d61d3ad85fe3046"
    sha256 cellar: :any_skip_relocation, big_sur:      "7fd0d6b273632b3aeea56e8eab6514ce2d1517d02a5ed5d1b3063b5c26f5282e"
    sha256 cellar: :any_skip_relocation, catalina:     "ec0943072965c84e5d190c6f725d562e28c998241e0226339dd0042115bc3240"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "97bd3b31c81ad7501e3c791399ba678b9014eada9f939ac42ccfcda7135f71d4"
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
