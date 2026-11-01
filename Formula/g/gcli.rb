class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "ec9150b79af2a4a8333152a93085efa95bb1419a9e0c48b63f916974fc752bfd"
  license "BSD-2-Clause"
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7918700cd15bc09c073b03283a9881236d0b0d6f50485ef93c20555d088d154c"
    sha256 cellar: :any, arm64_tahoe:       "e52413ae615a54141056c60ca8217cf3c3d10483a63f2b52c8de3c31b23596cc"
    sha256 cellar: :any, arm64_sequoia:     "4a2bc07bce36b9b117e04622bc41495d686ab6a789dd7d7cc5d8b29aed4ddadd"
    sha256 cellar: :any, arm64_linux:       "b82ff65a6c6d0b1971cbdd188ce908baedde614cedd9c484eba69ac43959e4c5"
    sha256 cellar: :any, x86_64_linux:      "179a88f0ef54bc3efc66cf651f57a55003c7e104d43a2e9808e1aea789069e06"
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
