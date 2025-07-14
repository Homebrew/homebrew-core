class Libmonome < Formula
  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "b98bce2a99481fc3aa8a29fc60310180d24473fce86f5edb55ddfe84d9e9dd69"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50321cfdaca220bccec61c6ec8e142784c3f02879656218b88eaeb660f2b8dba"
    sha256 cellar: :any,                 arm64_sonoma:  "c219343f215edf79464c897022ae2fe87c8e5c075279576330ddef92ef6d7274"
    sha256 cellar: :any,                 arm64_ventura: "f1a92fb448fd91324d64ac05c4b7ee756d3bd24e2306a6e4f3f59633f5eec3e0"
    sha256 cellar: :any,                 sonoma:        "034c7bbcda99a0adc3fdc38ca23f8692d1199291cacbb35a2bcee1c3ad79b2a1"
    sha256 cellar: :any,                 ventura:       "ed75041e84f7adc92cdd481496634297651dd1974ba9289cbfcedc14d3554507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6689ecfc0c1164b27ca775cf5748c5ba6e44c484a3026b7d02ac7be08703f254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40da298d04ff272067c8f88b2b71e939eb0a7e98387a05f976c6d75d4e0c5ae6"
  end

  depends_on "liblo"

  uses_from_macos "python" => :build

  def install
    # Workaround for arm64 linux, issue ref: https://github.com/monome/libmonome/issues/82
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    assert_match "failed to open", shell_output("#{bin}/monomeserial", 1)
  end
end
