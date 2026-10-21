class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://github.com/Julien-cpsn/ATAC"
  url "https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "7d39488b1dbf30ad370c6fc033922db104aac42796188ee870adfe3e735d9d54"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "67388cc622f5850aa2d7f1af0f199e27233ecf4d7e8d05ad86f03afd26489d7a"
    sha256 cellar: :any, arm64_tahoe:       "1b37cd21394c7e22cebe4c97817cd731148a5917d7aa6e5169cb45ff19670272"
    sha256 cellar: :any, arm64_sequoia:     "65c774f656d17fe803f1ee0368f7282773365db68ce38f852dc521dd0952cf8e"
    sha256 cellar: :any, arm64_linux:       "dc55cf5581582f8951902223f2acc4d1579c013992825884a2f62a5049215980"
    sha256 cellar: :any, x86_64_linux:      "c2a6027961705ce7c5e9fc2a4a09efa1ecca2886e9c238e796e0e1bc391c34ff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
