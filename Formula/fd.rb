class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.7.0.tar.gz"
  sha256 "13da15f3197d58a54768aaad0099c80ad2e9756dd1b0c7df68c413ad2d5238c9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97281975697f4338e4ec9adca10144759323332a9976d4b52f73078d09fec55f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6714a0d1e7be8c21bfb980d76995b38a3e27a2809530d2eacd5ce6c62b96451d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25b34d213330b2ab2e72754101acd9f77aa95ef6b2ee7909dc7df97cc06aea9b"
    sha256 cellar: :any_skip_relocation, ventura:        "9a0154c723baedc9bed355b282c180b62d265bd7b30413a5857cf2c17e14a12d"
    sha256 cellar: :any_skip_relocation, monterey:       "a6bf3e9aeacb4a6e1cff103480bbb1b77fd2c5c08ba06b74cafa7a6ebc03a449"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeb2360ba43e2e508e45f0e832d53f11b4a89d209ae619af9d16f24159aafcd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b83137db9ea1cdbe2c8af884325afca72a11a0b1e640d97232cb164028bc4ef"
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
