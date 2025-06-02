class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://atac.julien-cpsn.com/"
  url "https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "3d4465e8328b38e81b7975e397db1a2bc188476ea2535e43abf5d18d096968c0"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ebd98ecdc06c79922c8bf73146c8a411b7fceb80f49bf9f4dd09f8895f4beb0c"
    sha256 cellar: :any,                 arm64_sonoma:  "e8a41c139803c5add18c3d8756d3a4d75ba2b135308d018d9a1188d8d7a02425"
    sha256 cellar: :any,                 arm64_ventura: "6a5e8120569837f2bc1db0cda36cfabf12678a3b9c48100f567d88a4650c8441"
    sha256 cellar: :any,                 sonoma:        "d4f9eeee1cb9bdfa18686389f0e763d43c21cb3270758a935dad12db24f95b80"
    sha256 cellar: :any,                 ventura:       "617e75c59ac1eb52ea51733713d5b0a36e2385f29e7e8d86c03b59fba2140fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9996a97ded1435336043d3cee1d75131e217bb25c9d55581367995f2badb19a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0a3e49f63594d0eae5afb8f372b4db7a76b11759f4f49da1fb60377ed661324"
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
