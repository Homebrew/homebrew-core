class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.9.0.tar.gz"
  sha256 "f8b5008655b810b9ff390b50b522f130a2264981b0e03030e8653ddd8cc34a4a"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5aefbf153469d76a29078637ecaf29fcd0ea01bb7e4c50783125b724ef528f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d4b289524162783f5d0a7faba4154c409674eec25febdd02121a00557c1540e"
    sha256 cellar: :any_skip_relocation, monterey:       "acf5c0ad4ddc7e6381b037249e4d7f76eb636cd1faea4173adffecf524d77bb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "075eee68cef594866b780645be5f795128e9d1a2af3ba7b054ad422e1d126431"
    sha256 cellar: :any_skip_relocation, catalina:       "1ab8fa326b32a62852cc582c70bda7a01bfa4468263e0ff64ff014518abf6726"
    sha256 cellar: :any_skip_relocation, mojave:         "1ee66c5891a38d1e70e8562509534308d1f1dd22ff15cbfd8207d48abb022916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba0e8bd894fd97e12b7607738c8d631323e70890562b10af4590e9a4e6b47f9"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
