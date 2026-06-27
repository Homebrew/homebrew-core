class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "205cf9fd858d9e7f9a65bec000efa4feeef0a98f3a1e8ba1f1192f9c63d4f832"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a0150452291d4c6b5572ecaadf5e67748d6d931b4bb1e1a8322ee2db119e6d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "760cd7ea534535abd9e80ad2ba05351a02eab22a19b3a0272be74ffe30a17d36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6657514f9a0b252e49f71fce1d26874db89f8ba48ac1296d2a7c34c2ffe8cf81"
    sha256 cellar: :any_skip_relocation, sonoma:        "c760237c8cc97285e7b78666ded31bb95c2a14f6b1e4986dff01a43b604c2e5e"
    sha256 cellar: :any,                 arm64_linux:   "7775fe90a7de3025a7db451366263a27bd6b4ceb056aa8374f6af7422bae34af"
    sha256 cellar: :any,                 x86_64_linux:  "3785ba860615de515dd5a779af4ec0665b82ee836301c17041d46d5f5bf42936"
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
