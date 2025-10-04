class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "5f48c3f016c1ef92c53b319ebdf751e66d5757070fc9ae678bedb185a450d426"
  license "BSD-2-Clause"
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4d7caade5034cc4d6ebf73e1c06cb8515960ad25cfd950037973aa74a8160b7"
    sha256 cellar: :any,                 arm64_sequoia: "c112e5c69bd3ce205ceb5db87cc09bd5940944de0c4d2965488ec450d8693bd2"
    sha256 cellar: :any,                 arm64_sonoma:  "0ecf6b4b9fbcb95dd4647f7c1e52648be667de9b97b5c78dcd1d9a1e9fbdf415"
    sha256 cellar: :any,                 sonoma:        "396486cf5de6c5227d655c3c5784d2046e5392f664f9252fc2f4c43f41bf5c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d507874360785300c20d56d93c959c0a26e672b675d725c8928bd4dbf7afacfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6820bf551219d8fc3c5310af586490792423a9c8dfe4c53c6a908cba10046eed"
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
