class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "64dbc95602f37087024684389528a0718b95e205afeb2c54d8dce8d5d437fbd5"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c151060df081310fd7e0261047be58dbf368f3e62e3d126305a2e3c838caf182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a07540731fe479aa722609e44aa92f7030bb6bc2a37befa95f240759ddd5764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffeffa1db4877e24cc0cf540a7d978cbe81c2c7fcf7207255a54d23704abaef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c236ecde14fe835bf5a9ca9ed898001fdf2ea46eb74c71327b4f88f7f5e698d"
    sha256 cellar: :any,                 arm64_linux:   "a0abab45a22a946b60d097b8f0fd7da1217c61bc7b7fcad8ff6806013bdccf61"
    sha256 cellar: :any,                 x86_64_linux:  "495797e60d956bd9cb28a9073b84175d22e9415f5a7b342610274328fb5a75b3"
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
