class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.3.6.tar.gz"
  sha256 "50a0eece4cde19605cd2b7ce7719755a4484952e7792338ec303bb5489466a2c"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cc18e90088f9793243355b4d5e65b7d471f98f5bcabd7aa79e58d4693d970de" => :catalina
    sha256 "24b9ed3dff88348367288b54b7152e7c0bb7337269288157e5cde194db5baba6" => :mojave
    sha256 "bf6c7fbbe0ae41f885ab8d38f47987d5157a0e3853ba88510cfe868e60723664" => :high_sierra
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
