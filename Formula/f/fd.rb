class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.3.0.tar.gz"
  sha256 "2edbc917a533053855d5b635dff368d65756ce6f82ddefd57b6c202622d791e9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2ec4d643aaf8f97580605119094a20a8616c59d7274eda558df3920797885d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9886f37be53878a004d8283e01487c5f88b2f40bdeea0444269d2720b9fc4b9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60c11007de37751d8d11f1537109c172005e1302a949c561b723646821c2f8dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "152d79c955c2e5ec1fc1554df762571f79cd014a52b41f855617b9a4c084c580"
    sha256 cellar: :any_skip_relocation, sonoma:        "c406da15c1c61643c924dbd5cb6fc28445291e73807ac112a8478fcbe2417ef9"
    sha256 cellar: :any_skip_relocation, ventura:       "7031fc0224cc81ac2f32413f27703a51f2876d0356527d88156b911ef999d0af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd34b505c728e111d57fd9beae2984e6164eb53d62fab13609ee7c3aa29a5030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa7ba3fdb0288d5bee2b1650b31e1f5a587a65dae81c5ecb14aa9ad94d91352"
  end

  depends_on "rust" => :build

  conflicts_with "fdclone", because: "both install `fd` binaries"

  def install
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm? && OS.linux?
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish, :pwsh])
    zsh_completion.install "contrib/completion/_fd"
    man1.install "doc/fd.1"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
