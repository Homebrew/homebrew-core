class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.5.2.tar.gz"
  sha256 "bc66842481d2121f58e7b178b449b5d387078fabcf712355e8db10f9a7af2cd7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82e95f39f0878dc71777d11d1fc48c569d2d8ff3547d34415790c0b7727c25ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c60f538e91a7d3aa9a58796591481aa56f40403cff30f815a95a878d6a47b4c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75a630fa700af78a8811260aa0a7cb32ffdcc08d081af62e2ace45f014abdbe5"
    sha256 cellar: :any_skip_relocation, monterey:       "8b8a1dd1aefd695ed351742bca5a63947be2f920fbdeb5450d37704fdbf51422"
    sha256 cellar: :any_skip_relocation, big_sur:        "db002a0e9938e9d67e4c42b3aa496cb593bedf0f16af7228294b0fcd3571059a"
    sha256 cellar: :any_skip_relocation, catalina:       "bc79b6a44e97187ec10587407803b3d066248cd7da6088a4fad28c1c5e488415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f91029a001585eaee0675c876e50b729b34f5f1eed473e4f2515df6e90734c73"
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
