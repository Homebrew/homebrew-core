class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.7/oksh-7.7.tar.gz"
  sha256 "98a758f590bc570e657263f56eb81577a018ff6d2f6e085f8efedf9d68749f95"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9793c9e02f01a8feff896ebd1bf1779f9cd3ce9b028b8f4882c9c11bcfc8eb38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1595b03d4c714d2c27d0e62bbcc9d13b68852c19ca3d83d08eb3523277a8555"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d838994b217f2fda5f7863ddf7f7219cfe10d6341109ab8f5049af5ada25b6be"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d7155672ef96777d6c99ae22019f151ea78fd6b7df4d5c2017659a796952ca"
    sha256 cellar: :any_skip_relocation, ventura:       "9c9215d0bc365cceba31c7663bd89d50eb90b20f64f9a54e15e62bbdcbb2e8ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57077f64c3422719c5855422574060ddfd32773c6b59f69842c5d9184a0ff18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53579c85a910b31bb43252b91eb9fa6701b47774df80257f5f865ea3c8aa0f8d"
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
