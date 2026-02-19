class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://atac.julien-cpsn.com/"
  url "https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "79a5171a0af3ac99086d6e02d542b0c6330600517f1460cd291d2edbe331b461"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "663f26d36f6d20a16ce4623de822aa4b7a460ded7b5ef0cb2deacd8b09ae9be6"
    sha256 cellar: :any,                 arm64_sequoia: "18b2909c261d5f7106947beb76279dbf6b60792742ca65b8ad8052226d53ff97"
    sha256 cellar: :any,                 arm64_sonoma:  "b0a868229e3ca876054705b6c82691df09b51ef287be1a3650bef9b597732da5"
    sha256 cellar: :any,                 sonoma:        "b1a3ca4d5cafd6b572f01cff8d50c67a900ec520842ff61112588a0ebf090b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3a67ba1e163c6e89d879df3564c32d5caec9d08e81bd3aedd8a3e39ab4695a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8783a29ce8fe794e012cd6c1d2fb6d73fcefad1bc2453f0365e9eb1198dd218e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    # stdout is not supported, so install manually
    [:bash, :zsh, :fish].each do |shell|
      system bin/"atac", "completions", shell
    end
    bash_completion.install "atac.bash" => "atac"
    zsh_completion.install "_atac"
    fish_completion.install "atac.fish"

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
