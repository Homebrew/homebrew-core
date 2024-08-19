class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.8.6.tar.gz"
  sha256 "4b7a6dc5f6f3da39c3242856a1c78734c7b14bd801dc4d7e32bc6f5a1809bc63"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3171b8c25d69f276f61be0c7cce9ab905e54ea4011a484e0ba9330a996352563"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de126c3169480e0d90144eaad355ed031b62aa2b8149a8a02c917414a0fc9f73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f57d8cd7e8e943e316f3c143e11c76bc0263db43f756b6fcc1d1a15e556ca80e"
    sha256 cellar: :any_skip_relocation, sonoma:         "80b7ebca9ea3f802c5d0b489e7bcbc756e0c49d1894fc615c0fb7b71bc460caa"
    sha256 cellar: :any_skip_relocation, ventura:        "4f1fb5fea01dbec1ffef839f7f62ccfa99392dd079c69c561d2a04cc0f4d530b"
    sha256 cellar: :any_skip_relocation, monterey:       "9766a8bb7449d7ecacabcae13c0d780792323c435ee1852077d2249527b3d1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d2aa5853dadf6a50d4942b8258b50b7605ae4ad1d0d7b213d52c890128cc3b"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
