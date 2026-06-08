class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/4.3.tar.gz"
  sha256 "92d4061252ad3fa625df15c5b22d746222ab82f65e42bb91acc54c01d3189a19"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdc2dee44dc40c676e064aab5796165bfe1d820142929345ef53b8845e2bacf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdc2dee44dc40c676e064aab5796165bfe1d820142929345ef53b8845e2bacf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdc2dee44dc40c676e064aab5796165bfe1d820142929345ef53b8845e2bacf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad764e1cf808ddb2c61c51f25a92313acfd811c8e1eff0e9a2f5474c2a1a697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ea6320d40215f8a4f6400fcbd813cfee509bb12ff6a0e6ed1e8ae7bd29b0aec"
    sha256 cellar: :any,                 x86_64_linux:  "8763e14e11fba93370502ab1ee8d2192e80ab84a3738b12ef07c42e275da4019"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w"), "./cmd/clx"
    man1.install "share/man/clx.1"
    bash_completion.install "share/completions/clx.bash" => "clx"
    zsh_completion.install  "share/completions/_clx"     => "_clx"
    fish_completion.install "share/completions/clx.fish"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_home = testpath/".config"

    assert_match "Item added to favorites", shell_output("#{bin}/clx add 1")
    assert_path_exists config_home/"circumflex/favorites.json"
  end
end
