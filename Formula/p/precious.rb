class Precious < Formula
  desc "One code quality tool to rule them all"
  homepage "https://github.com/houseabsolute/precious"
  url "https://github.com/houseabsolute/precious/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "01f9a43247d42c84c85f5e07721736264b7fdc1e4a6ec5776b17563b1efcef5a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/precious.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13e61bab5ea58804dd6869c0489300ccd9d01d971c38a2d243d9a03dce4da0c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b50c34ba56c97deb50b4c4bd30b8db046db520ad338f29dd7e3e6d4b64f4547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d73a4676c1a07e7d3af036d88f5a903cd7866e276400652d2ea285c2b9a9870"
    sha256 cellar: :any_skip_relocation, sonoma:        "2122714da7a13b32617137780f7bcdb8e01f561ece3b4fda0aafb54c43675be4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "109308f96f8ed3f4d36f7f8a6f2c61174e202bd99d2baec0dd7a3a4fcfa5017f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7c6b535d38cc25ab828dfb49bed6fed78a8c72341cbf65e3a4544e3b8704cfa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/precious --version")

    system bin/"precious", "config", "init", "--auto"
    assert_path_exists testpath/"precious.toml"
  end
end
