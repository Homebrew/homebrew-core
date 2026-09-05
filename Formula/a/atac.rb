class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://github.com/Julien-cpsn/ATAC"
  url "https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "af34280a23cf3d8cf1b6d79b35a61bfcaaac661e79358166b05548b5153df53a"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "54cd6d2a327960ffc2a522b881a40f77470d66a2bd36b673083692c2ef2ebdff"
    sha256 cellar: :any, arm64_sequoia: "da57838ae9fd6b63987a5890235df6e98edcf399f0703fc959089b09cded5d61"
    sha256 cellar: :any, arm64_sonoma:  "6e5c38d01a67f50fa345dbd9bc0de70eb5a72094d303bac2d06976889c5920a5"
    sha256 cellar: :any, arm64_linux:   "542025beacdb2fa6e91d2d61627fca95a7d413f806b556e773661c649aa5a7de"
    sha256 cellar: :any, x86_64_linux:  "c33c50907289ffbcca9d58c7eea967dfdadb187bf00c087824047d8d56d096de"
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
