class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.37.0.tar.gz"
  sha256 "5521fc900bed90e1258817c6da75e07fc0122d2a56c8c7d67304c7f1e2bd5cc4"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90bb0b0aafa22dcb5fa10f8ee685c0d8574029ffb55033b8a8989b46a1939aac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3401c28e14405f4c578572cfa5b893b5aed9d35cb74ebf87d85b6059b77bf16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbd39bef9cfec0eb30479e72a3b920ff61aa0c65c19d909f50507744338963a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "efab2c77d5f6508244b047a58f102961cceb66a7730fcd873959f36cbd0db6ab"
    sha256 cellar: :any_skip_relocation, ventura:        "96ef45d6e42da2b9e3c06362f74a6f60819edfaaf1be33cd9f0f290d116b4f16"
    sha256 cellar: :any_skip_relocation, monterey:       "bcc98fb64b301952138137183e2ef82fd136cc62faa5319e7a93d4e2713b53cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef945822758ae57a7fa74b763aa5814f1e944b8d3214179f0eb89cae058f7e51"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
