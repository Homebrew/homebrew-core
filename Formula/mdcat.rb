class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-0.30.3.tar.gz"
  sha256 "e4f96b9df490d1a1b11d8a7c84ef5636b242d3f3d5fe5fae1ab53847a80a7eba"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ce5ca2809e397b1c4719a62aa3df92fe0a44da53dcba5c905b24f03030c8c41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c15f6a825c8cd101a5779d5562fb6e99c4c3d1a6fbee6ef382a6517b88dc190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cbe23086bce83fb067e4961c7642f7de68d2a20b5561963b4183ec84740525a"
    sha256 cellar: :any_skip_relocation, ventura:        "e38b0b6176f7c8e9bdbf97aff82a980c372fb807c045430db13376be34914303"
    sha256 cellar: :any_skip_relocation, monterey:       "3110279991169a72b77a3c50e2897afc28dcec3849c28ffb0d94bcd267e5ac19"
    sha256 cellar: :any_skip_relocation, big_sur:        "b798a9861ad684617c555ddc471ffee01127f6ea6756ee78adae106097de1ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e32e0a4751313c05f69edc63d59b222b3af75bfbfcd66363729db7afe11d65"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
