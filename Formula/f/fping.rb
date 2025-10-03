class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-5.4.tar.gz"
  sha256 "be320771f075e47dd7e5704b485e9bdc7dd11107884345c0f7c18749357f668d"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?fping[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09b1beb48ac9e6567406b8f6e76519a9b63382e71eadb3924bfcd18f3b847f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b71b5530f094ee89dc363ff4c467b7b7c8bf7d1fec8bc58115902519c01f75e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc1f9f33b3118bfb502a76da0eb5be15848ed9bfe07d52a7e100e372c107868"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "686f4d1537b0c0fd71e317bb14457861c32939cca5a2074a219b052f519f2134"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e66712d26fc23dddc6d6ba045a9ba555eb21cbc8131b8f7f8daa6c4f3dadf9"
    sha256 cellar: :any_skip_relocation, ventura:       "3066894f8efde5abf4aa22bb9a0220cf9d5a19e5b3c175cdbc08802ee5234fb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e2633d859c39e4e49c4eae05cf72e6d608014c90cadd62c54edac5e02000fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc460b6d9a105579d6a1341c78e789f76a375cca9a68d2c2b3c3fa813d62b6a0"
  end

  head do
    url "https://github.com/schweikert/fping.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/fping --version")
    assert_match "Probing options:", shell_output("#{bin}/fping --help")
    assert_equal "127.0.0.1 is alive", shell_output("#{bin}/fping -4 -A localhost").chomp
  end
end
