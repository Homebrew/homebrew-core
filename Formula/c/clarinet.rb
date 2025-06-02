class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "5af2a139214e832a8e00cf017439d782a8927939ed1b42b2642315e317076da4"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9144a6664f831f9c73471a23c46c25b9bac30947b522e82934af99dce3309908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "480507ea6fd6a9b5423e85110771261854b0b8f6a47a5c2553a7469086936fb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53739b6da1e966aa060c5d06c0b3eb3d847ccb511122bc0c2de160967d4f094b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9e4822a6f43e6d78c3d284e819da874fb640cefa2de260d82816a80541e9a17"
    sha256 cellar: :any_skip_relocation, ventura:       "6d15c2314a51d508fab91353a54f41d8aa196e4607fe7cbea9c352383efdf1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90f25b1588fb618a303982815aa195aaa1881fb473bd61062da3bcf5fcce2ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fccaec5eba5c0a4c4f020ea11da6bfe508a64b500732b4200df1be1128b810e3"
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
