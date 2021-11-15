class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.0/oksh-7.0.tar.gz"
  sha256 "21d5891f38ffea3a5d1aa8c494f0a5579c93778535e0a92275b102dec3221da1"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d83e6295bf7be6c4933f8c173b69b829d31a0d94503da19fa035b6c81a38911"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11227daeea3128e2ef4f4b4e435eae213f2fb62c00e9dbd874df7cc0d4c018c5"
    sha256 cellar: :any_skip_relocation, monterey:       "83210b5f7433628585a27bd267b60fe28a9dedc127daadcfab2e0833800162d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cd5ef78a3dd5b66ee1890c586f3e508052c5d5a72ff8840139b8044d1b0cb27"
    sha256 cellar: :any_skip_relocation, catalina:       "864fe627a2dc5459983532a8caa65c322bca76ea6f53a263bcfa6c18905f14ff"
    sha256 cellar: :any_skip_relocation, mojave:         "90ffe56c170396eeca45344479b4574ee21d70daa4b82165c97d55a7c33cfdbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb076d21d0e8ce3ccd70976e7dfdc57a081deee333480daf85ccd6c2ee39e3f6"
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
