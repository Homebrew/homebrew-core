class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/docs/getting-started"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "858781d08b8fae7ca16272883a534b698550a3106539d131c5edcbab47442aa7"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48a2bdb76a728073b658fccb04c693fc5626cd7802a04d73ad4253b8d5711c47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d01706f895a1716a4d23e1f1422d376eea0fdd441641e1f80322b171fe9f3ab6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "764a9eec3febc7f71761fdf2450db5ec49c0cc5ca79c91d7e087471986ca347d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abfff6a4ec336ba634849137801d63215532ef7dcd5c9b8db7461dbe12726b5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "faa43e5ce13f6018913f24421fc89019e985c3dc35ba22ff1d400deb33e9f693"
    sha256 cellar: :any_skip_relocation, ventura:       "2e42202fe8a2b30c7d9fd74f53908dc2c9453aa3420f3d81ce51a0e2f49ddd86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4ed4c62cdaeb681767825af15285a64b79bfb90eaf1e0e9594da8941165c1aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f52a4c9ec45620c8aecdf6b0c729b7f76e2e05304bde97aa70b502e1bec439f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
