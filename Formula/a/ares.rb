class Ares < Formula
  desc "Automated decoding of encrypted text"
  homepage "https://github.com/bee-san/Ares"
  url "https://github.com/bee-san/Ares/archive/refs/tags/0.11.0.tar.gz"
  sha256 "fd8751de6c46eb523d62d4ca52018b9127b9fa5fbd4a372b7f22e0f9957f030f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef78e48f63a1af964da3502cf71ecd41039eeefa3fabfef3c4e831382b26f07f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1ebc203591b997591cf3f7fef4fb145eaf1c7bdda7c1b92a4a5f7c73afc3a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ed6c01fd307449f1f5f1d76f1de7dc4f804d1c57ba7bc106c9dbead3685ee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5acf01bcc2e7bb451ffaf5b99fc499663de093222b057b0f4d8f21b7239c7e6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "453b5cf8f4f29d7a0a5702569f9f149451bd5e19c313886a0e5024369cab3879"
    sha256 cellar: :any_skip_relocation, ventura:       "038f0c1740c55673f92e9eda04f45e2d1af79ec0c75a19d0495d0286c0fc1821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18bca98bf45a77d9f7358342a4196720b37d59ea4f77f26c9c8a36abe3a70c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bdeab88f015b3d9e745c63a71c680c2a53b17f9a81146ddfc1d67233d332ed5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # base64 encoded string for "Hello from Homebrew"
    input_string = "SGVsbG8gZnJvbSBIb21lYnJldw=="
    expected_text = "Hello from Homebrew"
    # Disable custom color scheme
    output = pipe_output("#{bin}/ares -d -t #{input_string}", "N", 0)
    assert_match expected_text, output
  end
end
