class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.8.tar.gz"
  sha256 "33ea8eb2a4daeaa506e8fcafd5d6d89027ed6f2f0609645c6f149b560d301706"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e361230f241f273ef878f5f2bdc2899a414a7973dbd65854e44dfaaa70efc95e"
    sha256 cellar: :any,                 arm64_sequoia: "c69f2a33c2f23e19668207e8a7f019476d48ddd21aac4ac297e447c4f368a8d7"
    sha256 cellar: :any,                 arm64_sonoma:  "d625684f40a9cfb51d98b1ca92f212e940074e4303931fd2e4cf3598b4c2f51c"
    sha256 cellar: :any,                 arm64_ventura: "c9f89d4196e6a7cc762937dea9cb6c2409240399ae95b5077901ae0bf66ead25"
    sha256 cellar: :any,                 sonoma:        "0f77335cd443a3cf8415f1bd44a82b8c0493aee02037130f829bce8dae1c9604"
    sha256 cellar: :any,                 ventura:       "fdd09def3431e2f0d55de1d4c9d6196c7ebb3cef7d82d0ba5160ebbcfe8243a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c392cca54e58164bdfd794709eb64f0a3effb3f3f996dbc112e440459d8ffa45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb65a129ec2f9117babdb703ec57e86857110f0e8cf8e74c14fa22f9c51ffd20"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.chrony.eu iburst\n"
    output = shell_output("#{sbin}/chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
