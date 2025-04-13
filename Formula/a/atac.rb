class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://atac.julien-cpsn.com/"
  url "https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "7c9a9c74817404e2a37ca07079acfbd0a903a46e1bc6ed16d7016f3aef912033"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bceb5c9d669139ef77459f67b13e37f8b9fa9868edf7a09874a736afbfe86eec"
    sha256 cellar: :any,                 arm64_sonoma:  "dfc1696d895cb42925a3192df3a8db275e74d5876fa994f1f4d56e17e09e157c"
    sha256 cellar: :any,                 arm64_ventura: "6f758d0ac90ad9239717ffe5ab82ca200d8f5881bde93b6f723833bc83af9813"
    sha256 cellar: :any,                 sonoma:        "d1c2a48e2aba41b13a2208d13efb9e636ce242093d658444827165691062c93d"
    sha256 cellar: :any,                 ventura:       "4db31e02a125103b5ec81c70e4c8c5c04857f47c0d263921887777834edf581f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cba126f27443f50fb231cb586a28c00b272921c611522b657d438c92b3a4c5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22eb7018a4ca2a2aa92895f877f813ffb6210a530bf0961de2719c2c9762fb64"
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
