class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "13db2e352206a26b35480ebd062ff93f10659a771cd785cb72780a0c9061454f"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ea96b0f2335e3b8466fde6db538f6495c76c97e6f15724c6ff7e1d24ebedd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c84cc60505feee7f759169fb4819aeedfa82bc3b1c23267a515a50a7ecf70e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe39aa23a34cb9771c60e62da7c73d1e3f5bfed4e0aec49f2f85933eace094a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d23d29e1fa407e7cae7392b71e505db7c9b7a3c7c90f97361ccf7e9179c44a5"
    sha256 cellar: :any_skip_relocation, ventura:       "90917209749cf8ea57f7831b57362930e61803b80af002e7b0179965eda5c585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0b512e3ae10ec4fb0319056dd8d56b99fad20f800c4375cd5fb756aaf3822f8"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end
