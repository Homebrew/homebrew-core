class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/refs/tags/1.3.3.tar.gz"
  sha256 "3f90068fe61f66389fc097e0125776181615acd57cd90487076914ef310e3e6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "195a5a242cc43ded9929dcfacfdf78386b10940a70ea842883e38e8a698ee620"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe74428364889047aaca99b9798a649740f1d4502c0c1158a1b196b615342e24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f2d8a70df57f7851ffbf367718df7196e1e1eac96dce7782b010542d248b35c"
    sha256 cellar: :any_skip_relocation, sonoma:        "caba266a509fc8a19393e6e8adcc6f99833c61a609ab32f61dd5ba0368ca1ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4739a1dfdcd3f8519c77a6033454467d9324b8ff4ef4bb0b83a0fd2524479b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c6a79c7e283a1012043142168a5eae7da1ef5f7bf3c31c449cf231fe52029ec"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxslt"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
