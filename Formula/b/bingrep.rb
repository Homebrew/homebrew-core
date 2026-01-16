class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "8bf096df68736561b40f56cd1feb4834014cd11c0a28b33e74e818618c62e100"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1878348be278edd0d51079d6ffa3b4ff61f7735256fa47a622b0d870655050c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfe4b3c4ce2806ce0743bbcc6c2cce92e3bae51cbcb33f0649afbb9177b19899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "523a292dc08aafda7688f322792fbd71724df5463f8c4e9e94c795ab1c180708"
    sha256 cellar: :any_skip_relocation, sonoma:        "94d00c5d9b0b82421914bcd4f385dd139cddaecd3e0b395beaa6a5a4f1c317ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea34405aa7f4b7c1f1080a6f6d58392c261121eb8dd92993fb5fc8e367983aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb3fa1bf3e32bc5dc2ed33d374dcc9967bc3edd92a2332451d7dbe8e985335b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write <<~C
      int homebrew_test() {
        return 0;
      }
      int main() {
        return homebrew_test();
      }
    C
    system ENV.cc, testpath/"test.c"
    assert_match "homebrew_test", shell_output("#{bin}/bingrep a.out")
  end
end
