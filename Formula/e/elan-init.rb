class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "47db0835fb55ce394b4b10a41ad414831ea3a33f44c5b5c1f1feb28b44170b03"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c98f09e8ad0d1d0a6571ff4a3191355c5d7a4dc3f406c43b8295bdf8d04c289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2dbdd3b3c78bc9b39e2a09efaabbae4115879a377ee6eeaa7ab09e4d3ee8b95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7e83cc46ec88becb47ed816223d8f33844207baa06ee06ec2edb55d62469d8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aea9617dc272dacc99fe46890ccbd692ad1dbe099a4eca45eb498352836898df"
    sha256 cellar: :any_skip_relocation, ventura:       "6df9763566d60e2cd8c1f536a1fbaa4c943aa196c6b38770ffbd541efdd9faee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e74a7723c370df806b28db12b15b2ec97e80adc936039156516ffb642e67238"
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
