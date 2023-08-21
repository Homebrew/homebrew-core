class Hashcash < Formula
  desc "Proof-of-work algorithm to counter denial-of-service (DoS) attacks"
  homepage "http://hashcash.org"
  url "http://hashcash.org/source/hashcash-1.22.tgz"
  sha256 "0192f12d41ce4848e60384398c5ff83579b55710601c7bffe6c88bc56b547896"

  livecheck do
    url "http://hashcash.org/source/"
    regex(/href=.*?hashcash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbd73ccbca122c860b2377fecc209cdf20f5615cad13e0fa267ccc4d14919483"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3453259cebd4bdb0d392b804b72081e8197ba2680e1ec486c8dad75df78b8674"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a58aab9f64cd4e97938df6d17e88f8d07549d9d84d3499e0c2d071664660132c"
    sha256 cellar: :any_skip_relocation, ventura:        "37de01797dca207a374a2a102eadf45b5fa1d9f594bb1787519f2253215f8ab4"
    sha256 cellar: :any_skip_relocation, monterey:       "cd1ae797834ad6d0e0eafb9c7e4189c27ef9f06ab204a03ed2de82762fdf48be"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d72206542ef1e5c627cd54327baa1fa5b5c669445ba4879aac6dbe4c23876a3"
    sha256 cellar: :any_skip_relocation, catalina:       "1865d8db05d392b73cf26b0d873b397b087ac76f6a71c6bdbbf9f5888d46ef15"
    sha256 cellar: :any_skip_relocation, mojave:         "775184aba3e61dcabed2020c4f2bdda029561badd41aae6d75c56b7bb564a7a3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "acb58644b209a262a1f8aea8c4f40e078f4e76742d0339c4e240f92bdd2fb290"
    sha256 cellar: :any_skip_relocation, sierra:         "af78a79c6b0dbf5267781eb209cc3115f43dcdfd7a389c2740262bbab3be3c20"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b9ab067b3001c71dc5cfa3085bfcd204cb4837fd6c87f5ce722bd77b8a629850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca20a448bdeb6f1db4f657235b39a74e3a26ac00474ee196325c494c0beabe67"
  end

  def install
    system "make", "install",
                   "PACKAGER=HOMEBREW",
                   "INSTALL_PATH=#{bin}",
                   "MAN_INSTALL_PATH=#{man1}",
                   "DOC_INSTALL_PATH=#{doc}"
  end

  test do
    system "#{bin}/hashcash", "-mb10", "test@example.com"
  end
end
