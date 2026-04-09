class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "6498bb187ff460cc148c1c84bde358ad7dd39345e179a1a9d3b802d7242e07e6"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "310a875f71476dced834607b28cb194d82942a371c024b8ffba33d3c622eb95b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d4e1c9a49cbe792334a358eaf35e74a3dd1f5c68a052300124d76abdd6ec79c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b45ee841a1a07cc25551d029c8c8553beb821ac41d0679c3185001c01fed9407"
    sha256 cellar: :any_skip_relocation, sonoma:        "de904556f2b687e3296f31b3b6fee58db48680b6f4915e4f453864946be2e14b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "057cc88b142123a1b3229ae4c3671cd2d1051f3f5d04955d97ad32ebaf89d0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae9e05851b938bce71fe629175f576001e253d33de010c66a1b101878c484262"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
