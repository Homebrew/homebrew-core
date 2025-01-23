class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://atac.julien-cpsn.com/"
  url "https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "40595898622b3cf2540d6e6e1bb38959d1a59451c4da8a86d3660ea8e1ef94e8"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce5f3928fbc429786e273084c33babc88f907d0175f747d625a852197db074af"
    sha256 cellar: :any,                 arm64_sonoma:  "956cf68c882c25a7212e4c9d6d2312005e9f5e271565c77a9bb7f7f8e24627a5"
    sha256 cellar: :any,                 arm64_ventura: "6b80f5ab9dcadfab3e7670a00446bc466bdedb77bb95c068fa13d883fd208b58"
    sha256 cellar: :any,                 sonoma:        "d1bc5efb7dfc5b69ee1b482943c58c38df7e3ae49364edde5ea162b173978341"
    sha256 cellar: :any,                 ventura:       "3ada5c6a72f1c794d9ca65fd5c5f53d49371bd05ea4d3cfd5598fc16106689fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d028a40d0235c7325ef751b42ef33f2f9ad66c357990bbc29ab39361d23738c1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    # Completions and manpage are generated as files, not printed to stdout
    system bin/"atac", "completions", "bash"
    system bin/"atac", "completions", "fish"
    system bin/"atac", "completions", "zsh"
    bash_completion.install "atac.bash" => "atac"
    fish_completion.install "atac.fish"
    zsh_completion.install "_atac"

    system bin/"atac", "man"
    man1.install "atac.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atac --version")

    system bin/"atac", "collection", "new", "test"
    assert_match "test", shell_output("#{bin}/atac collection list")

    system bin/"atac", "try", "-u", "https://postman-echo.com/post",
                      "-m", "POST", "--duration", "--console", "--hide-content"
  end
end
