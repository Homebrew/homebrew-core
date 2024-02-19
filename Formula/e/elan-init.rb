class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "634366078812599bef485eec3af25bc3fa88da6dbe39414128b9c9e14a681a0a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "468673d385f124495e1e4c08789c3809736e485f8e1fb2c13ccd69a9d8fd03fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3344477e7ad981331e8eb1d1a6378a70d84bf2a5fa3e5ae7aa7da25a95881bcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bd0e137a5032d8451b60cd4842020260d489a659e994b0e5c42640a9bbcce8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b029e69209be0af7302ee2363bcc8e03b80e0e5050c3dd3660d6374326c7764"
    sha256 cellar: :any_skip_relocation, ventura:        "103deb977242e39eb69a8968676abc178820bbddcac7a015484d448c403eff60"
    sha256 cellar: :any_skip_relocation, monterey:       "99b1b5f8bedc016ff7c29edce26735ad24602e0cc690910944c5b9057fda503b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4be45c30e1b3f7f98450808352649799d4ef26ad4afa1c4ca621f5571e07a58"
  end

  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

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
