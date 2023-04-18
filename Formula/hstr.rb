class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/3.0.tar.gz"
  sha256 "6d523914dc3af243f5895b2e52d39e3cc53f1afed6562f34a29da4d4467ad7fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e038caf68b868edcc063b4c3f483ba14f367b2fdab828ce3a12a67cdb555797a"
    sha256 cellar: :any,                 arm64_monterey: "2168f54d5943d04bc18e247f71afcbfc8c47bec3ded766aedffdb76effe22a4d"
    sha256 cellar: :any,                 arm64_big_sur:  "35c143224aa3753cfe405e9a1f0d1a95800aab427abbce423ffd280252335000"
    sha256 cellar: :any,                 ventura:        "7328fe1245b0f086d44eccf2990dc5704535c4c804ed2f5c8a9788e35adbfaf1"
    sha256 cellar: :any,                 monterey:       "9eb68d3e204b7aae4cafb54f9dc109b12a346111085fd608aa29ec1621ce98c1"
    sha256 cellar: :any,                 big_sur:        "75f41f8a07b866e9cd9808b630513b01f116332535882f90d8305a48cb5ded5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0780ff9efa358bffb0349072c5ebfc669f52e22fbfaadc549e7fec28eaa7761"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")
    assert_match "test", shell_output("#{bin}/hh -n").chomp
  end
end
