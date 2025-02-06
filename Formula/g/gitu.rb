class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "0ccf2b6de3a45091c4e8ddabd6539d5f6fb53526d1e2928a4bbfdf40808236d4"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43db867350902afc24e3b7cacb38823050e43a0c84003822bf2ff2a6cec22857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d195d1d745eb34a41fd74d53a17369cbffd0fe109e3ca91e3f88da2c09c3ac95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ca0f0d47a4efeeddc2143a7c2349fac93233871b41af31eb1d5a1eba3efb81f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ece66de3fe57ffe5441128b9197734a6f6245f4fe7700fb52d662de12bea5129"
    sha256 cellar: :any_skip_relocation, ventura:       "21c8b2b42f7decfce9e7cf652241f7e247593326bfbfa080c0282fedcfd708b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "573a485a9652c7cba59593a3067c7fd4a31247d9bcb8f9d3840f335001ec2412"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "No .git found in the current directory", output
    end
  end
end
