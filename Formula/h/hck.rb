class Hck < Formula
  desc "Sharp cut(1) clone"
  homepage "https://github.com/sstadick/hck"
  url "https://github.com/sstadick/hck/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "5ce5fc816e9e009dafe8c42a0bd6b9e6c8b7ca5a839af6a797fba9accc569242"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/hck.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4df79cddcbf021932b7300c9a6cc6cdebc9b9d85a551353456d4f8c8c07538d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b3406b0ab689cba7e8d8ffe40033e3b3867ac0527a3c7a903915254532f6a6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93ce77bb3b5310079ada1d764f560e692d96b4ca65aeaa90893195aa5d58abb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a147eff8f1e3e69aeeaa681afd81dd69e19bd865e0b675b21fc680fb752c80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b6a6b21c1ecb5cf9da85863fbf8e23e05275e1a6883552199fb697f12f99e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b46f9971e8d64866900c0b57f67903455d7c0dbeebb4a5fa59e093118b150ff"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/hck -d, -D: -f3 -F 'a'", "a,b,c,d,e\n1,2,3,4,5\n")
    expected = <<~EOS
      a:c
      1:3
    EOS
    assert_equal expected, output

    assert_match version.to_s, shell_output("#{bin}/hck --version")
  end
end
