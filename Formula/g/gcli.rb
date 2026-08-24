class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "3dd25f636e439f7af6187248e46f2b4078dffdca4fe2d506d0edb275515d62b4"
  license "BSD-2-Clause"
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "74d37ebad8e191a05263ffe032655f5a0e219308d6422b9514b704899aefd377"
    sha256 cellar: :any, arm64_sequoia: "9d4ad7fba0f3b7acd2ddb2564b15e0ebc2129b77b6f5fc10492f7a15450ebef9"
    sha256 cellar: :any, arm64_sonoma:  "da4fe62505adb8f7ee4de20db42a8e06f65fa780302a9b33ef905611a1d0c47d"
    sha256 cellar: :any, sonoma:        "b18efad19821fb1a2ad7b44a28f0d1f9eee41dda49cb82e8a180752252cb13db"
    sha256 cellar: :any, arm64_linux:   "1b4e90b7ee1c9a8ed8f3df564588ce9f8c49772e8a5d0f4d049656fb63998087"
    sha256 cellar: :any, x86_64_linux:  "08bc9ed83025725125b2f7854d0c2989ffa62c3603f40a4a0405bd93c3a16042"
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
