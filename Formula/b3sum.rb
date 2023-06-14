class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.4.0.tar.gz"
  sha256 "012db50d676c177842650ff55235990b8dc73d18e4e4730824773df22257fb51"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1648fe1afb9e245affdf3422b8dfc6c775463ad7f46fbe1f2fcc3958ac82105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce3b657beaf627398b2a801b5a81d4fae81c3396cd0d97e267368a41754da711"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4415cdd7fd6b04d20fb2ee51274aba74ad9e63de571f28d7550dc091fce88f29"
    sha256 cellar: :any_skip_relocation, ventura:        "cf1181ce9d02c2611458c4a5e319646b693577159cc551dc3c873b63939d996a"
    sha256 cellar: :any_skip_relocation, monterey:       "6ddc78567e31da2a5dd4840316ada3f1deccc8c6bbcf8b7829d09be412869c1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce3fb43692a515207c5fc0d2c10b9164d98c4d801be2ffb1abfb0f44e8cddf86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3676a293a136c39b4b96647c40a59510da2f8b0d9fa50c26a1c108a9d7089718"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
