class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.2.tar.gz"
  sha256 "6b51aefe515969785da02e87befafc7fdc7a065cd3458cf1141f29267749e81f"
  license any_of: [
    "CC0-1.0",
    "Apache-2.0",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e07d5d585f8a33c42965dc6da2b1d46898bda73e1b604a63c562b73603be1c3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad04179c8c37e7afa0fd83d28af8fe27607994fa8c39f309bd3e3c69b613086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e906f67b37fd1f69281f71039786cf49bc8aba72b5879cc1dad720c414ad3982"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfdaa91ad3f88c6fb734acad4adfd0e272881182d7f9810223964d1003c94ab0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8786885a570f8b3b2d6d66c2dbf7cdbe0317c4393bbf6a390882a450d6d5f4aa"
    sha256 cellar: :any_skip_relocation, ventura:       "61606af42f07a5a6dcfcf1b2ffe6f76b046213cfba6f42a2afa1d06a798dc37b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d94b9769af2a11c7ce1e4e1e8ecdd6c649ee305ed58e0363da5ce4509afe904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c65b99dc2886d78591ab8ffcb62c760869a41c4c30b75677ac07830f96e4756"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
      buildpath.install "README.md"
    end
  end

  test do
    output = pipe_output(bin/"b3sum", "content\n", 0)
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  -", output.strip
  end
end
