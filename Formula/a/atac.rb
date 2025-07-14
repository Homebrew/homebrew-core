class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://atac.julien-cpsn.com/"
  url "https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "d2f8163a8df224c7dd07e5aa2db6c000938102fe5b637e583e2a123a731c1ea5"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e737c4c00bf8ffba6c530c72621102b9653dfce857b7dd2cb14c1ea5817a3724"
    sha256 cellar: :any,                 arm64_sonoma:  "7541ee353b11df848ccf8f43f75dc1bda53d4ff8643aa00dc715e40f089198ad"
    sha256 cellar: :any,                 arm64_ventura: "92000dfb088d67ada800262ae6af2ba24eacd72974b9bb962650453b4f794f01"
    sha256 cellar: :any,                 sonoma:        "dd3e472045a1be0d034b9ad6183ae9887bcf766d873695a947ac7f96820bfaaf"
    sha256 cellar: :any,                 ventura:       "63532ef5bd19e50d3d4dcb987a53b6cbc8b846ec25e5567145674d2fed98ef96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1382e745564f69ef678cfe6d546b49123c46dfe45839aab2ebc6b383501d403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a747db706a32341404be11a517168bdce345bd6bd5834e7b43137af94d8dcc83"
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
