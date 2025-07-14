class Lutgen < Formula
  desc "Blazingly fast interpolated LUT generator and applicator for color palettes"
  homepage "https://ozwaldorf.github.io/lutgen-rs/"
  url "https://github.com/ozwaldorf/lutgen-rs/archive/refs/tags/lutgen-v1.0.0.tar.gz"
  sha256 "6fb508e4c8ccd08157c2196114f2d3c8f513f521e1144979e47135fd852b338f"
  license "MIT"
  head "https://github.com/ozwaldorf/lutgen-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lutgen[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c73ad8ebc351acb49f31bdc6e46a480fc4ca8b788f728a07d5c813afd2ef5142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d28ecbf589261b5f70b99f94fe1066f82fc92f075a91d49111fc5d055be95943"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfdae02120487b9fdf526d5a599c169144adf1358f1f3e2a54ed6696060aec10"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f450e1b1ccae1c0015e8c67debeb200d439931651b25fc8b7b232fd429e8cee"
    sha256 cellar: :any_skip_relocation, ventura:       "b4d999a19d71079a5cf05495dcbccd38b7b979c591587abd320df7aed8dc9a67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eb44214f2e8eb17fe10c0e7177f8ca20220b714bf7d90aefd040c213139f7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a7819713a140640e8d7e92fbd98f7da430cd7696873048565f71872ce566cb1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lutgen --version")

    cp test_fixtures("test.png"), testpath/"test.png"
    system bin/"lutgen", "apply", "--palette", "gruvbox-dark", "-o", "result.png", "test.png"
    assert_path_exists testpath/"result.png"
  end
end
