class Bao < Formula
  desc "Implementation of BLAKE3 verified streaming"
  homepage "https://github.com/oconnor663/bao"
  url "https://github.com/oconnor663/bao/archive/refs/tags/0.13.1.tar.gz"
  sha256 "34cdbc1bc30ce41394ffd52e8a29ab4e5956ecabd7c4db26ffd992d306a59d96"
  license any_of: ["Apache-2.0", "CC0-1.0"]
  head "https://github.com/oconnor663/bao.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9825859095cd723bb032520fe1548c694f4a413a42e874525c7dd5e16d0340f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e72ccd2883d2cca743e0436eae25cee929d330d0238df74a7bfa1a48d48cf9ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ee092a0750ef69e210081b7bb3d1143365755d330711ce42bfa9ce2c4774b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b7ca0bd24b20763777ef735beabb064f068174b3f4ac3c76b86d33834cc37ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f56a2a03eb3c7c5087b44266136a6f90f868f1f312731811fcb2866d421113e"
    sha256 cellar: :any_skip_relocation, ventura:       "c1be9491ec695e53a1e9d94391081618451b25f6da26bea453faf7791cc34e48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61983b766ac21aadef6a9afa6d4bea203c87dea271b180be9a2fe9554e81bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02ccf54ad8acabb8b7504b3b9e6ba699a50f96cd487f89a2859ba565b6476de2"
  end

  depends_on "rust" => :build

  conflicts_with "openbao", because: "both install `bao` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "bao_bin")
  end

  test do
    test_file = testpath/"test"
    test_file.write "foo"
    output = shell_output("#{bin}/bao hash #{test_file}")
    assert_match "04e0bb39f30b1a3feb89f536c93be15055482df748674b00d26e5a75777702e9", output

    assert_match version.to_s, shell_output("#{bin}/bao --version")
  end
end
