class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/refs/tags/20240422.tar.gz"
  sha256 "4793404735db5ea79f790cf865bf4fe875f9c5c23b1b8da186349f54b3a32281"
  # https://fedoraproject.org/wiki/Licensing:MIT?rd=Licensing/MIT#Standard_ML_of_New_Jersey_Variant
  license "MIT"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab0f6c0bd87940c78c8248e2237bf186ad68cfd1938049b1692c5da7e7acfe67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef91c2756e105eb6da2da397b1e349e7f34ec9cce138a8be93f24d784e4489c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc60e225008e6a90e2c014e760abdb6fb746ee5d29b9a37424a41ad47ac93be"
    sha256 cellar: :any_skip_relocation, sonoma:         "10990a99e78c6fa3b03cd1f302b43ed6007264f4de507cda08b8fa5b08b368da"
    sha256 cellar: :any_skip_relocation, ventura:        "8884561ebde218b1312f73ab1f6cbff753972db054984face4e7d42a58cffae0"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb9de2a01abd29de50eb68d8d1997250e85db278dd608cfe2af18dd5d935a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6d1fab4ff8b522266e3f6e73a57c48f0f469f116dbfb3df0f0dfd9f175c909b"
  end

  uses_from_macos "bison" => :build

  on_linux do
    conflicts_with "gawk", because: "both install an `awk` executable"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test")
  end
end
