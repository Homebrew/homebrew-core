class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.6/oksh-7.6.tar.gz"
  sha256 "26b45fc3dcaab786db6b87dcd741ac572a7ef539dbb88ea22c43ed8b54405c74"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cac543c705cf353172ad80014192ab32009e13c9282f76351ee8fcc69a18cce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b8cc437a4c6ba61ffa48e22180f780f44fee4b289fbee9a5f3329c73590eb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee1c16d52c54180c06655dab3844a24793616a6133caf129d9bc97c1cde8a9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcb1a11d8fc619e3930e90169b176465952ed0433ebcb542be10f3208254e6c3"
    sha256 cellar: :any_skip_relocation, ventura:       "ab69b4780f3199a9e48b076759d0b3665f48ea991ff9d1ea7bef5547a123c88a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65142d25fc17a41c61238259bb23c356a0c2e4f4254a9cfd62bbd73dbf687a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef2738318950f311d1aea31ecbd228f3f556e2266612635da2dd1ce5d5b1639"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/oksh -c \"echo -n hello\"")
  end
end
