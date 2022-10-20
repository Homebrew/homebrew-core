class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.1/oksh-7.1.tar.gz"
  sha256 "9dc0b0578d9d64d10c834f9757ca11f526b562bc5454da64b2cb270122f52064"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8859e5561db3f2bd97757668829e212622cf2c76f7e3bf21011107458ca8d8fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c5efdd49f60012609a2f0324afcbef94b107662ccf73a867b1925d300908ffa"
    sha256 cellar: :any_skip_relocation, monterey:       "9590eafe5164a3678e09a2e0563fb419a121dd84385cb330a81626f38accc125"
    sha256 cellar: :any_skip_relocation, big_sur:        "388fe821f4a4ee040658e90e890820c05da0e62b3efb541183a0afbe68a28ff7"
    sha256 cellar: :any_skip_relocation, catalina:       "c1b5d2e29c17a199e9591946454814876d8b69ed4db13c578e3015a8221102cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b74d7caa1450e8efe8c3b28133e864b4f660aee0151cc3f297262fb19de51c7"
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
