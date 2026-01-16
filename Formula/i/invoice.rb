class Invoice < Formula
  desc "Command-line invoice generator"
  homepage "https://github.com/maaslalani/invoice"
  url "https://github.com/maaslalani/invoice/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f34f20f6491f42c0e94dbde433a578f0dba98938f2e3186018d3e16d050abdaf"
  license "MIT"
  head "https://github.com/maaslalani/invoice.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3666463773abc10aef019abd54dbac8b4b699db7783fc0b54e7be6c59b5844df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3666463773abc10aef019abd54dbac8b4b699db7783fc0b54e7be6c59b5844df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3666463773abc10aef019abd54dbac8b4b699db7783fc0b54e7be6c59b5844df"
    sha256 cellar: :any_skip_relocation, sonoma:        "334d0d037207500ac6199cef1639e08c759cdf544f2232543c05f7d32aab631b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "724180390bc239a924d1798745bea25a5ea50fcddc1b8f42adf4941e71be76a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d75038930d911627bed4b65260095a76623c0062c21f77d501451029da75de9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"invoice", shell_parameter_format: :cobra)
  end

  test do
    cmd = "#{bin}/invoice generate --from \"Dream, Inc.\" --to \"Imagine, Inc.\" " \
          "--item \"Rubber Duck\" --quantity 2 --rate 25 " \
          "--tax 0.13 --discount 0.15 " \
          "--note \"For debugging purposes.\""
    assert_equal "Generated invoice.pdf", shell_output(cmd).chomp
    assert_path_exists testpath/"invoice.pdf"
  end
end
