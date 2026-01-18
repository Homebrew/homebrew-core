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
    sha256 cellar: :any,                 arm64_tahoe:   "e4cb80b9bef5eb789f32ecf4f5cfdfe7902b90f313deb075fb00f7beabac109d"
    sha256 cellar: :any,                 arm64_sequoia: "47f8d424b8248c2f74f396f9309187b43d064ba5c0e3eacca3349280044cce21"
    sha256 cellar: :any,                 arm64_sonoma:  "9bea57b9f5a74412381ed49257330b3257ce541c1afa95dd0e57fcddf6e94902"
    sha256 cellar: :any,                 sonoma:        "644647569cc3488beffb05f57d9842fa81e78192849f96819311f5d36f6e0175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82857ffc399e1601beafe572b038435d92a47417acb309ee041ab45a9df8c4e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebdadf93fa2cba6e03d1ff96f277aececc9f3297ba5d49b1027d7a9ef65063bb"
  end

  depends_on "bison" => :build # requires Bison 3.0+

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
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
