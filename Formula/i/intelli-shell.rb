class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "a9e852d7b677fe6fe50ae072fc8bdc75525f825319255346496e24d50e2ab11c"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1def62e97bd8b80353677f9cf28300a41f5e93e6f36d8e117841fc81518538b"
    sha256 cellar: :any,                 arm64_sequoia: "ba515a6e8e991f5d221ca586d53f9ca6056010305ed5bf2af40a3c2ebe056d46"
    sha256 cellar: :any,                 arm64_sonoma:  "461b990b141a88175075993117f22a9f1012fe2e233fb74b070526e0fc386236"
    sha256 cellar: :any,                 sonoma:        "48ddd3027f10de5c7180207299347f27e40752b37d5f0b4823a93f3a9687171c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46bb96298b8d895db04ed5a8fafb21ebb31c229cdb6fc30f99936fb1ea1a891d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a264c5a5f815074e7be18caa3e2c1d5462f29005bdb8916a818f470f8eae5c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end
