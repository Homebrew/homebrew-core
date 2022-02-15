class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.11.1.tar.gz"
  sha256 "b206e042c0a535b4435523e578c3c72cf87af62689cdfa0c3d0f1f2fe275ace1"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4db5cfe66bb2c4c988e66b7c165e0ce7b31c6e82ac07e0ce754c9060c4986ace"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52b7da2b0193de3fc8ff10fb85928b9fa70201e8ab902393e713417df60364bc"
    sha256 cellar: :any_skip_relocation, monterey:       "023540fbd6fb0a8f3f8400d0f973faf89e0b0789fe46165e24419eb5d11ee300"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d68cd0b00066f173da087e6c35d086d3e681632bb1d8978259760340346b340"
    sha256 cellar: :any_skip_relocation, catalina:       "7b3abb1b78d284aeac3626794c2fb0bd7f50361f89a988c9c3c6bc8bc5fe281d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "176ca83b7b30fff43a6f54428b8c1d881d120570cb857e7aa3cf186ad13d7dd8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
