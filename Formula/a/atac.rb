class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://atac.julien-cpsn.com/"
  url "https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "79a5171a0af3ac99086d6e02d542b0c6330600517f1460cd291d2edbe331b461"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "42781046c144e343aafd6b19753793003ea4d267931cbc4fa79d4aa1483b7d2e"
    sha256 cellar: :any,                 arm64_sequoia: "c5dedba31d079bdcc86d0d4819d53a0bc7f3c0190b00f4ecca80943894d16bf9"
    sha256 cellar: :any,                 arm64_sonoma:  "4719c8cad3a935cd7dbaef659d1fb50c576884fc446031770f8e0722d083433e"
    sha256 cellar: :any,                 sonoma:        "520a5f26b41870ba4c755ec5ee88502e72897f3033fca9e47a0ccbc1cf7ff62e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afed6fbbdcd5e7f2bc28f0fe228dfecca4fb3516fd7d9570154e485558a49513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e89c4945b747f27ee12ed861d7e3c31a0e6c91d7840e25a169905d6372e3b4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    # stdout is not supported, so install manually
    %w[bash zsh fish powershell].each do |shell|
      system bin/"atac", "completions", shell
    end
    bash_completion.install "atac.bash" => "atac"
    zsh_completion.install "_atac"
    fish_completion.install "atac.fish"
    pwsh_completion.install "_atac.ps1"

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
