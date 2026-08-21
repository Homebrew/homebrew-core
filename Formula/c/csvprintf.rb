class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/refs/tags/1.3.4.tar.gz"
  sha256 "dff2ecf046bac822bc34fc8a452cecae3d22abeb85a9ac950dafdec4fedf0db2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8093f20f2513417d1d07554b202666f40b039f639b7cc74de4410562ea112ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81610eb3bb319cf45dcd4919a56bf75a12a88563fc0dbc81bf9a2fd91969914c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea94b60237e1b83e202e309b85b90a9b6e373ac456a21876bc29cfe548c05b4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "75cb3f9c5ad5c7ec334b55b5532912bb9330a67a84eff81ff14910c6ce9d2465"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076afc7ab3bbc4c90947eb6abe349d61823f5f7be53c1a4fde016a3a2fd159b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03999433d566187074903db24761528aa1e32100ff1b7fbc5fc1701f8fd6c5f4"
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
