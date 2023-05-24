class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.26.7.tar.gz"
  sha256 "8526dd722bc51aff814b36f892acacc5b6a62e79ded1ee6f7d9ea47f345db4e8"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e82bb3001b4f51dd22f9f4c09b18ccd33eb40e96adfac279793590fad58b383e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d061ef3000fca0f8bb03a47fa4b10f3caa4b7b9c00a072d917529597ba3aa92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4a581f37300cf8df468efc770de9177b484bf05674c7a0efab545da7c0336aa"
    sha256 cellar: :any_skip_relocation, ventura:        "51f7e2acfa46c5b41500db36be205043bd94d4f682404e7debcaefe42b2d4663"
    sha256 cellar: :any_skip_relocation, monterey:       "de20bc4b0e12c9737669645a44ba009c63d501ec938be13481056520048b61dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fb0f7bcb67d74c75cbe49317bc0dc4a275a84ebf91ade9c52efbb8459236bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b0162072f06f1c87f8e591d636d2e68f7c90703dfcaf6e1a843d714d3c7d667"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
