class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.8.2.tar.gz"
  sha256 "db55c067630074724fbd3fbf85ebf3de1cf5b47166f80866b58c72f2ef2ffd48"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e605e4a33b7eee14531ef38afdb9305646bb42a22b4bdda7188a21bb23264cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "715bf4cde3524653f06802cd0bcc5debd0eb99b9648703afb26b926edc1cba35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca0d7ed5b4de3fa3dbe101f2ba58e56c93a26cf9f5c9e73a9a01d332fb7ca848"
    sha256 cellar: :any_skip_relocation, ventura:        "a9371a596dfb676e86081b468c4a359b864343db6e7592e1d10826a46018e669"
    sha256 cellar: :any_skip_relocation, monterey:       "e5d603e9fb1afb42f3fc722bb602214c6c374145a643cba4ec85e4f954729197"
    sha256 cellar: :any_skip_relocation, big_sur:        "6364134fc66b29d0bbeb7be1955c19ec8fc3fab4dfe23f3fd11b2786f88ea8f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d5a1fa2d57be20ecc6873c2ec19a0f76dc9dfc7dbfaea05fb9eced2fa3d2504"
  end

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
