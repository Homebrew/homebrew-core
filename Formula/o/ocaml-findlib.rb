class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.6.tar.gz"
  sha256 "2df996279ae16b606db5ff5879f93dbfade0898db9f1a3e82f7f845faa2930a2"
  license "MIT"
  revision 2

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "b87ed1fe983ab11326fec9a012141bd8a3b880354e478dcdef6ab8359e26cbe1"
    sha256 arm64_sonoma:   "27db02a3efa66607b5131c5c7e2fe171540b3967ab0e80da5c62252b2cf8936b"
    sha256 arm64_ventura:  "c9b81ddf8a113a064ef29cc3f0477a608367cec59a87885101ae5ab7063010dd"
    sha256 arm64_monterey: "e37c0b5bf1940cbbc4bfb6406e10d060aa76164bb77d598adf82834a9b725a07"
    sha256 sonoma:         "c7dd3598b58e99b1dfcc4060a1b4bb244e289ae9a13fe98914f29217b5ab67d7"
    sha256 ventura:        "ba4ead7c276b54aa9c48c6e2b929aea8f04a1cbbb808fbfb087a5d9f03fe47ee"
    sha256 monterey:       "5fc964c610117d95d20857f3ffffb52d6f518fe502c74a3ec40e108e60d9e40d"
    sha256 x86_64_linux:   "75203b91c65f7c6ca18a0105202a5a6aeffbd225a4f97fc7a1d977bcaa403f30"
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    # Specify HOMEBREW_PREFIX here so those are the values baked into the compile,
    # rather than the Cellar
    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", HOMEBREW_PREFIX/"lib/ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-camlp4"

    system "make", "all"
    system "make", "opt"

    # Override the above paths for the install step only
    system "make", "install", "OCAML_SITELIB=#{lib}/ocaml",
                              "OCAML_CORE_STDLIB=#{lib}/ocaml"

    # Avoid conflict with ocaml-num package
    rm_r(Dir[lib/"ocaml/num", lib/"ocaml/num-top"])

    # Save extra findlib.conf to work around https://github.com/Homebrew/homebrew-test-bot/issues/805
    libexec.mkpath
    cp etc/"findlib.conf", libexec/"findlib.conf"
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end
