class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://github.com/leanprover/elan/archive/v3.0.0.tar.gz"
  sha256 "d1862df96e98515c5799bff168987e69382d824222e3fdebb4f41c63ef75d32c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "996fd2e6b7ac46ae690d97b7ac0e1baefe4664d0236a8a462526680825619482"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b4d9b6ab44dff35ef3ade3c1e8f425042f05d25f7b04fed7f3291b4c46b3a27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94a8d34bbfb3d7ba6fd72cf5c25f8a9a8a8874be4b7cfae46c65073caa7e8b20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f337d05a721349509c7896bc699e2be0f0301ec66ec0ccd36378559b689ff0d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e34fdc9a3c381fd71652ed930e82a59dd74b7aa93ee527113dd3eebd24e3b311"
    sha256 cellar: :any_skip_relocation, ventura:        "9c5781b03a1d973bff99ecc5e1fb85c6445779df7e94fa4490e42cd9437a66c2"
    sha256 cellar: :any_skip_relocation, monterey:       "b6afe6d0327ee99a7fa5cb81f1f79e669b9be6ec1e0b544b10ce7575abfc3101"
    sha256 cellar: :any_skip_relocation, big_sur:        "16ddfdd1746bbf89dde1333a15959dc07272c9925ef16f04822c5bbdb0e508a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5898a72ec21a103ada571b069c59f2497730c2163bc45c2e32c5c52fdf205360"
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
