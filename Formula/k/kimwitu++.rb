class Kimwituxx < Formula
  desc "Tool for processing trees (i.e. terms)"
  homepage "https://www2.informatik.hu-berlin.de/sam/kimwitu++/"
  url "https://download.savannah.gnu.org/releases/kimwitu-pp/kimwitu++-2.3.13.tar.gz"
  sha256 "3f6d9fbb35cc4760849b18553d06bc790466ca8b07884ed1a1bdccc3a9792a73"

  livecheck do
    url "https://download.savannah.gnu.org/releases/kimwitu-pp/"
    regex(/href=.*?kimwitu\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a97df5c3b9f227ae34a2e87b7a4a4ec12988efeceabd2137b0dfe619da8ded6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b54a601b646e3e2b70d0ef3042a6c2180c51dbb0371078134463de043be1d4d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2291141a641d3529702fae53de9669d0b557694157b5c196eda1c56484ec67a7"
    sha256 cellar: :any_skip_relocation, ventura:        "d434374974309b23dcf7aabe1778ac02b2328173c8723db794f9b22b8309db8c"
    sha256 cellar: :any_skip_relocation, monterey:       "6f02b1694547ba1ade265cbfaf9cf8357c64260e551abb34d8f5b3341dd16eaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dcd1be78b92b98d73dad285fbaaf507bdc23805835a51f56236ddd8b0eb73f5"
    sha256 cellar: :any_skip_relocation, catalina:       "470e06521034cea8db6ad07e8aab45c5bfbe3969cd03891799348eb4e9279c90"
    sha256 cellar: :any_skip_relocation, mojave:         "067f8d375baa815645201a091c2f8325b469e59d9b2793e5a0dd83bfd9350aa2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "26ba22bbcdbea896f4af405631bed60dfc198757b6f879765e8d85e373b122db"
    sha256 cellar: :any_skip_relocation, sierra:         "a5dfd8382b50fc856ba741b79cf7077ae741549b8b8ff32ce727cfd7e8bd2a69"
    sha256 cellar: :any_skip_relocation, el_capitan:     "98c3516d1f3a9b17397354d8dde712f8a8c0f97ac919c65fc468ab4569534cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cece1163e971acd007363d1bd70c61a0d85a056b85cd878d53b520c330479754"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end
end
