class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "ed6c618d9c67fedfca0fb4da79d8a0d9d27efdd82cc74b372d6fe5cd483d6456"
  license "BSD-2-Clause"
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa08502f495b8da28c73595e81a9bfbba39e6b02d6f757a0ebeeeb4c25d10096"
    sha256 cellar: :any,                 arm64_sequoia: "380b2b85130a47601bdec226fd7532738974f8c51a76aeddd3eb3614703e569a"
    sha256 cellar: :any,                 arm64_sonoma:  "9fcbf2ef78ca26c35678348a357ff9b4efdfdd00aedbb466fc965a3c6edc3acb"
    sha256 cellar: :any,                 sonoma:        "b8b7629660e40871400d712dbef0b0b846dda685fbde24e2ca6101a3cc11efce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27951a21f506fdb8540527197be0d98a2fa6b9d48f27c5cad4bf2bdcd651df2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31eef2f32ed72556de1717ca1586265344e53758bb5b900b23cdd7d70a7a3799"
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
