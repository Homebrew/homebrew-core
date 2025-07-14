class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.8.tar.gz"
  sha256 "662c910f774e9fee3a19c4e057f380581ab2fc4ee52da4761304ac9c31b8869d"
  license "MIT"
  revision 1

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "9364a3bfccbfa17b1de67b0811237748181251ca875105e010deca7c8b8c7c38"
    sha256 arm64_sonoma:  "45a15d80b15f259a02a9665646a85ec6844445670e3b7f083ab1bcd447b2d480"
    sha256 arm64_ventura: "70d057e89961c844b0a54234a7630f0e73ef9654bda57da6da9ac98bd4ea6e26"
    sha256 sonoma:        "7d40608def1547faa7db079f9d6e8e1bb84ecd22bb3b51af0562416eae5b580d"
    sha256 ventura:       "9953fc46d00a4952c6f5982e241743aee3a1587abbaaa2ab084e3c1a07f5f94a"
    sha256 arm64_linux:   "946dec027ce88f81d2342a021bb3839ca38d7eda3e8777bb115f369575af4cd6"
    sha256 x86_64_linux:  "2aada46fd1e1d708cbb09f084dc896e26d35869ea8fdfd2830fb0d31caeb0b27"
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
