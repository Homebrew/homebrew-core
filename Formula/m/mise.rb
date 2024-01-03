class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/mise"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.1.0.tar.gz"
  sha256 "0b78bb36f4bf566d0c2f11d1d31d4cf452b8fd73e04da3d0e6b407f66ee96697"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f163393707981d453974e2d3b6fe88e61f9d73ac23c9062b4963ab93963e4ac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "290ef1b3da58b1f88652bb8e6d49a39a9ef3dbf1f204de92f656ccd79ad154a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de30c68963a3e47186ce5574bd4a537b733a4a3930fb5c64b4e08d87d6c42302"
    sha256 cellar: :any_skip_relocation, sonoma:         "f24ad54b5fe70aad59d2dddabe649352f987b37d7574e88bcdb344ad7392a996"
    sha256 cellar: :any_skip_relocation, ventura:        "fc29adb9329e2bcbeb87d979d478c7601be0affd14af6a1d88d00a5b2646debb"
    sha256 cellar: :any_skip_relocation, monterey:       "83eeba1e5e23ca4e6c7e53add8b5bf5af1fb41b783ab1562da95b2c264fb6f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab75b70870fe302bce9bccf6a01f997fac4a273c1e0fbfb0501de5231e83bdc1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you have previously used rtx, your configuration and data have been migrated.
        - Configuration: Moved from $XDG_CONFIG/rtx to $XDG_CONFIG/mise
        - Data: Moved from $XDG_DATA/rtx to $XDG_DATA/mise

      You should update your tooling to reflect the new paths.

      For additional intructions, please see https://github.com/jdx/mise/****.

      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/mise exec nodejs@18.13.0 -- node -v")
  end
end
