class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "3dd25f636e439f7af6187248e46f2b4078dffdca4fe2d506d0edb275515d62b4"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f9586c60e4106a7ce24130470d27ea5c42919c15e84c393faa37de33239138e8"
    sha256 cellar: :any, arm64_tahoe:       "36ade248eb726336162db2dc1e7ae6d7c0449a2634db0f1905dece713990046c"
    sha256 cellar: :any, arm64_sequoia:     "3c025a47ba65cdad547f36b278ea1e843f277172ae5c73c5b3d0dbfc7f302a9d"
    sha256 cellar: :any, arm64_linux:       "dca2d6aba7965011a7797a46b5c0b1d3d02bfdf02a80478387286a2a00e7cc27"
    sha256 cellar: :any, x86_64_linux:      "6419fda9ac61bac95264a7de8bca890df3a7ad0f7f018786926fadde030ae60c"
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
