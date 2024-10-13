class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/0.19.0.tar.gz"
  sha256 "d7605160d3589578c84a919c09addd8f4bd1f06441795192041b491462c9f655"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1d80eb335f983f52e453c866431540bf6f82d7cc0305ab6056b8deb5b5cce1d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdf4911e6d932582f34f6495d7be2d40b6121744bc786ea50009756c85ec2ff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3e800a012e94dacdea6b6aabd85473d86ad2a1dcbc4e1bacf4d40468095d77b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "687f701da328d54544bc41c71f9e6dcbe6d07f2d0aa0ae7026f991f55dfdd174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f47a9beb2fbedbf9df2fd66b12a548a12f7af74e06581db39991efc2a8479faa"
    sha256 cellar: :any_skip_relocation, sonoma:         "a281c73412748263b833d42f59eee5953448081a1c97dbe9a6da09ba326f340e"
    sha256 cellar: :any_skip_relocation, ventura:        "981da27f7464c0d49af7c30495d75ec9843a238e8a54e380662ba04cddd087f9"
    sha256 cellar: :any_skip_relocation, monterey:       "9b22f287c99506bccacfe72d63c6c6e779d7f2205af3b96416fafa1fb1798d73"
    sha256 cellar: :any_skip_relocation, big_sur:        "756dfee81b3616083db7708211371cecdc0b20b4066e39b7bcde3c961669c82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61c8d5426814597ee17d0dbd77ce3d4eef9b553f475f255b0c4cd091171ebef0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#\\w+", shell_output("#{bin}/melody --no-color #{mdy}")
  end
end
