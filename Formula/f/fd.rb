class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "73329fe24c53f0ca47cd0939256ca5c4644742cb7c14cf4114c8c9871336d342"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df54657784547cbc9fd37c071356179868df99eae86cc60c480ccee2df793865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22c913a776446f606f98b806990ca84eda587d33ec1776998450d32650a8fc19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50185800d3972a716a0a93233ebaf046711d92668432748bba229a96f7654782"
    sha256 cellar: :any_skip_relocation, sonoma:        "50a26e49e139bce09e9d13e031e417a102078ab9de58dbdfab8967ea80c339c2"
    sha256 cellar: :any_skip_relocation, ventura:       "e65ede7ae3e502e8e38cabca8ab95984b7bbec73a610efb8aaaa8ca8af7cf97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b69ad2a2e6805de8c26e192eae0da32807978cd9551b7863cee279208bc5cae0"
  end

  depends_on "rust" => :build

  conflicts_with "fdclone", because: "both install `fd` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
    man1.install "doc/fd.1"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
