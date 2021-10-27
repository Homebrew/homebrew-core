class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.1.0.tar.gz"
  sha256 "0bfba4ba71a9b04afbaa6bfc45c38e0598ce404e2cc5094b1d4ef45e83db2ca1"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca4e6057cfa826c5d349d46a5bb0c523c12ccc766f2796fd0eebe2e988d8274a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7410629ac8736ae399089cbc5740f8a3165e7644ccde8175a5002430d1029a76"
    sha256 cellar: :any_skip_relocation, monterey:       "5e74d1888584b67da7911a3d562098f584d901daf68631ca258a5df27f3980a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "92ed7f1c75302ca78d8b03900256769775c4e59a68e4f66fe096e97f8acf4203"
    sha256 cellar: :any_skip_relocation, catalina:       "e3625b9225421f31986d329c5fcf3967e98f1ddbb97e84e574d89ff4d47108e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8059c6780584b5ce84af8da9264af6e1dd9ca8476ae865c8affceefd515bfd8"
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
