class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.18.1/pup_1.18.1_source.tar.gz"
  sha256 "0f4ef7aa1cefa251226092414c8d86cda882150ca154be5ada311e88b7bb913b"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9784fbbe302adde2d504badcc6714393e40394cc64dcef8ce16be4a33db8d773"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6c5d1f84cf6a726eaae292ef7c8ce21b16eaff3f4c34860252a3341f92def44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75da2a5ce4c97637b9722013df11fb31bd1c2860282acd9aba6072797455b84b"
    sha256 cellar: :any,                 arm64_linux:   "e4cd54e5ddb115a7e29da3868522972bcb43a64cc9a3f0b883d3ddd78bef3f2a"
    sha256 cellar: :any,                 x86_64_linux:  "7bf1403006e68628d1371ba773e7a568c412336070b14cfd639429c0b631f56c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
