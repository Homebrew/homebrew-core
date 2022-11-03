class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.5.2.tar.gz"
  sha256 "bc66842481d2121f58e7b178b449b5d387078fabcf712355e8db10f9a7af2cd7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee51859a6e7b7891ebdd9fa47fcddbc93891e80e9abc14eb9e4452a2c9c22293"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82a08148076268cafd169b92060efe1296a4dd829ba86326f39ed6a81a5a652a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a7bbd5f1ad51c5a1a5c954aeb18acd7d3ad87b97fb1a0000ed4769aad3c24b5"
    sha256 cellar: :any_skip_relocation, monterey:       "3c9fe2714102de4053b37bd4277016813c672e23515fb68a0d091a07ef82b8aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "79486b2d4a4382ad07c32115f19aaea1748861a388b3944d5a01bdf44d8931df"
    sha256 cellar: :any_skip_relocation, catalina:       "f798baeb8004263db559093795473a21f18bd0b8382055409d20addb4ff24eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b74b028ad4b0efa85811f595dbcbc5612cdfe58a37de107bba9dab1256c4e3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
