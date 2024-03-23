class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.3.8.tar.gz"
  sha256 "f237c8ada75f03654963f57ad388accc3a538033089c49f39c493d81e90463d8"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "031b1f13291538e9bf8ea2bada9de9ea4e1e17e3fa5503c166cd17939cc7770e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ca9f1d3f92ca8fc2c3c12cd75d45bbb26bc46a2cf0e838551bdc99d5e054de1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cb9c7dfecca97c83c056fce4f80337230dca7f57ea06a862fdd83dc838fdc4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a994e0e7b6642f30bf3466927e7c54c3543fb0c4a94755cfca0dab34bf130eb"
    sha256 cellar: :any_skip_relocation, ventura:        "fe2bed3aaf85d3ba2cea61b8137606340849f1f28609e1e280b086c041b624cd"
    sha256 cellar: :any_skip_relocation, monterey:       "ef7f34d54de1b96df51f858813f5549491f4269845e830114132429b06f8e98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31c27b7f4b78a46cbc6f2c54750ebb955200b463c819c8a75bfe9d7dfaf4fc91"
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
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/mise exec nodejs@18.13.0 -- node -v")
  end
end
