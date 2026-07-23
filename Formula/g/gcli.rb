class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "b58210a3e705eb2393fb11d555125450e1f0757646a149d61e34094d9cc62f0b"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "34987ae4a8e8a73821fbe222ef7796b09d3575b8e6beff9d3398f6ca37646e5c"
    sha256 cellar: :any, arm64_sequoia: "84022420e87ea427e8543c023169239f697b4c18546c2a7201936de465fa61d9"
    sha256 cellar: :any, arm64_sonoma:  "98f3925649947bc318a796ab7491a417b5ef6d1ac075f3cd69ce05dd89cbff5b"
    sha256 cellar: :any, sonoma:        "64db44d2ec8a274cfd0410df7f9a8f4c07be6f0136989e942f864b063aab1076"
    sha256 cellar: :any, arm64_linux:   "605e45e157beeae5025afe365b38f5bca46f7d9c44fdaf3d56138fb4e88348dd"
    sha256 cellar: :any, x86_64_linux:  "288beac1060bc7ce7e25a2cf2b2eadc9b97f5053b1f0cbb11ccfc7c297377a31"
  end

  depends_on "pkgconf" => :build
  depends_on "readline" => :build
  depends_on "lowdown"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"

  def install
    # Do not use `*std_configure_args`, `./configure` script throws errors if unknown flag is passed
    system "./configure", "--prefix=#{prefix}", "--release"
    system "make", "install"
  end

  test do
    assert_match "gcli: error: no account specified or no default account configured",
      shell_output("#{bin}/gcli -t github repos 2>&1", 1)
    assert_match(/FORK\s+VISBLTY\s+DATE\s+FULLNAME/,
      shell_output("#{bin}/gcli -t github repos -o linus"))
  end
end
