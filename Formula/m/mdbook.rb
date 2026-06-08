class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "7c3e2907c0482fc9721a46ac42d7954600d795ce2152bed418553999ec1ee8f1"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8423cc7eb069257dbcf4fca0d6f4f89ea6fb3b2d03d4818c0bfcb6fb8b857b8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ab6045ed8059a8e4e8d5f784cfe15d641ee4180ab3478b01b7b99377987c7ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "705de83f96d28306c7790376276afb47ff394cf857341795df2a63773a4cb40d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3daf0a4f357a6adee15132021ccc436455074108f0950d78a71ee61920cabca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "500236101123d7ef468d597eb9600475f18baea01d55354e251e733bc9645dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42e14b4bb47b9ac0723d1afe41572cc6392ed963fdfa194d84393684a6252557"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"mdbook", "completions")
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
