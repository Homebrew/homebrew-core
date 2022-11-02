class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.5.0.tar.gz"
  sha256 "b719d87da077e35a7588541ba99acbd01e53aa3242b40e26c487d047b959247b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b6c2f81a45b0a64cd20aeebf14d95a42c7f2a100109ac255c733d8e1b211141"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c96299f12b195e6997487660ccfb6e78b1baf3a6f4b985d15eca56086f087cd"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a8f4015c5dc14f0fdbf8379e02e5abcdba45490186df979c5e294dfaaa819e"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa680c2a27e2d5bee1f561b5796c50388ab85f8ba1a1da6a72aee817e0e48a4b"
    sha256 cellar: :any_skip_relocation, catalina:       "81f74f4aef208298e92e54f25bc06b897305fcb229dbdb29a62937997ee6e39b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3dd91d1bd55eb5bbf9695bd5bb9f27d157b76ad6c307abea5cdd1589990fb55"
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
