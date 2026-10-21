class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "3dd25f636e439f7af6187248e46f2b4078dffdca4fe2d506d0edb275515d62b4"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f8f14770b891df8378b8effb7ab1b45be91f3050ccb19ea41f9690fc503008a6"
    sha256 cellar: :any, arm64_tahoe:       "e72794d14e2d63a4c18fadb58429ee9f12ed05b73a1b4f54bb44f424fa6a7d12"
    sha256 cellar: :any, arm64_sequoia:     "95b89dea41ddd6dac8096256a913e5b8dbe4472bc539bfb3b75895342428bed0"
    sha256 cellar: :any, arm64_linux:       "843a0f7cb25cac0a0167807caccafa3f6b7a4cfcbe7d203fbcca2aa55423dac7"
    sha256 cellar: :any, x86_64_linux:      "1bc37a3cda5c1eec633e3ec4f52192c648aef365b8a2ed9d027663c90d0b2538"
  end

  depends_on "pkgconf" => :build
  depends_on "readline" => :build
  depends_on "lowdown"
  depends_on "openssl@4"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"

  allow_network_access! :test

  def install
    # Do not use `*std_configure_args`, `./configure` script throws errors if unknown flag is passed
    system "./configure", "--prefix=#{prefix}", "--release"
    system "make", "install"
  end

  test do
    assert_match "gcli: error: no account specified or no default account configured",
      shell_output("#{bin}/gcli -t gitlab repos 2>&1", 1)
    assert_match(/FORK\s+VISBLTY\s+DATE\s+FULLNAME/,
      shell_output("#{bin}/gcli -t gitlab repos -o herrhotzenplotz"))
  end
end
