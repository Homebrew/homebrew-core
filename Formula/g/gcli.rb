class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d5024ffe77cdd482bfef8a0652285ce7a087d21c0e3ab9df821fc43565743538"
  license "BSD-2-Clause"
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ee08d1373d2499064b4517a6c7f45417b038760225ec08a6a7bfb808cb0a7fe"
    sha256 cellar: :any,                 arm64_sonoma:  "4a49e6b4e096f1f3b18bca384dbe31bf2bb87dafc73b9e93e305efe5b68164b9"
    sha256 cellar: :any,                 arm64_ventura: "9e59f53d2961339dc80707fea298b53a08c6878394c869610511c42086fa093b"
    sha256 cellar: :any,                 sonoma:        "2d36090b72facfba829e0c6794f5ba899f219695f7a23f2c4c7fce6de611e7e9"
    sha256 cellar: :any,                 ventura:       "49c5783f3e053707f650b2a4d1713b04d06e657517487bfcf017130a708241e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6138729b4d1b55d52616dc6e819c1418ffd1a58c41ec9a02be7f00e06702882a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5852a7a4dea782cf9ba7d0d9c0fe1be0b874661429cc8d81e3169861b76f057a"
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
