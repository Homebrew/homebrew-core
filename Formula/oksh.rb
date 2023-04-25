class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.3/oksh-7.3.tar.gz"
  sha256 "9f176ff6841435a55f27bfd3ebbfc951c8cca6fdf3638f0123f44617e3992f93"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bfcb74eb73b2cd0c02adf2e925eb88a3c3b7ba4d6cd39f8c0ffd44cdfbfff14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94873354382fcd1a5626129d1e02ce5a21ccfb38138b97435795576a3a05fe8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55bf4ee9842ff6a06dd25af5f2c95e608486d73c32d85ea30c26ea794cc8fe88"
    sha256 cellar: :any_skip_relocation, ventura:        "bc58bbee1f79c1d447db3d7b6d41f0b9447cd0dd63b9740f08680d4ae5ca7591"
    sha256 cellar: :any_skip_relocation, monterey:       "1bbc1d8b9c8839cc3769ecdd8613a3290739ead415fa2f512bfac2a60c219d29"
    sha256 cellar: :any_skip_relocation, big_sur:        "46efc44deae1592d8582ca61eca5b01eef2981fb6e8f115384863d23fdc6fbe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f69213f68417c956952c3b736d5a39da389707c3912d7d5045167147c6cfc1b2"
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
