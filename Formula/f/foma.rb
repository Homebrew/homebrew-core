class Foma < Formula
  desc "Finite-state compiler and C library"
  homepage "https://github.com/mhulden/foma"
  # Upstream didn't tag for new releases, issue ref: https://github.com/mhulden/foma/issues/93
  url "https://github.com/mhulden/foma/archive/dfe1ccb1055af99be0232a26520d247b5fe093bc.tar.gz"
  version "0.10.0"
  sha256 "8016c800eca020a28ac2805841cce20562b617ffafe215d53a23dc9a3e252186"
  license "Apache-2.0"

  livecheck do
    url "https://raw.githubusercontent.com/mhulden/foma/refs/heads/master/foma/CHANGELOG"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fd8381fc805c864aefbaffa5507624795d7e4674d4af8a1bfa9dba8a03c5eb5f"
    sha256 cellar: :any,                 arm64_sequoia: "7154bcdaad69b85097206e47d5c5ac9f6470789ca9f3fc7b5e9229bcfdde5147"
    sha256 cellar: :any,                 arm64_sonoma:  "0401b74c60a42645eed24732868b95df75a0f38ef916bc3b79c33976115a67ea"
    sha256 cellar: :any,                 sonoma:        "4b0436d1958cddeef9cc00e822f734008ae798196435bd33ad8520b8194c31f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "316d56312ba830eeae0e745a52d673103512f61431555dea4cd9cf8393e3a983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1bb0803cb28af77ed4bd165993c0c810bbdf66bdf3f29720b22a8957abb8583"
  end

  depends_on "bison" => :build # requires Bison 3.0+

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "freeling", because: "freeling ships its own copy of foma"

  # Fedora patch for C99 compatibility
  patch do
    url "https://src.fedoraproject.org/rpms/foma/raw/rawhide/f/foma-c99.patch"
    sha256 "af278be0b812e457c72e1538dd985f5247c33141a3ba39cd5ef0871445173f07"
  end

  def install
    cd "foma" do
      system "make"
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    # Source: https://code.google.com/archive/p/foma/wikis/ExampleScripts.wiki
    (testpath/"toysyllabify.script").write <<~EOS
      define V [a|e|i|o|u];
      define Gli [w|y];
      define Liq [r|l];
      define Nas [m|n];
      define Obs [p|t|k|b|d|g|f|v|s|z];

      define Onset (Obs) (Nas) (Liq) (Gli); # Each element is optional.
      define Coda  Onset.r;                 # Is mirror image of onset.

      define Syllable Onset V Coda;
      regex Syllable @> ... "." || _ Syllable;

      apply down> abrakadabra
    EOS

    system bin/"foma", "-f", "toysyllabify.script"
  end
end
