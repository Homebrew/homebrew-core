class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.2.1/opam-full-2.2.1.tar.gz"
  sha256 "07ad3887f61e0bc61a0923faae16fcc141285ece5b248a9e2cd4f902523cc121"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  # Upstream sometimes publishes tarballs with a version suffix (e.g. 2.2.0-2)
  # to an existing tag (e.g. 2.2.0), so we match versions from release assets.
  livecheck do
    url :stable
    regex(/^opam-full[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "44bc267a70ff1415b18579078b0c0086be293b357421cf412ae8aae159a05b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9847aa49b26c9d4b2c1617b8deea49267ac6b9a5a36960f69b24bae0a51cd43d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c849459999a80112ce32b900eb58f685319d6015ec11d37277b2b882630aa38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ec9e96c630178861fb91febdb336eea2a7a75a65078c1ce705c486da6d9199d"
    sha256 cellar: :any_skip_relocation, sonoma:         "03404aff94c2bc53da47c22b0d9b29eb0ad94bb139d33524be54d22413cba34d"
    sha256 cellar: :any_skip_relocation, ventura:        "cbfba87666ea314b0330e1798a978ff40dcb6ee85121b41c77745af8fcd3a9ce"
    sha256 cellar: :any_skip_relocation, monterey:       "5b2fbb37009313861f684867054972b509be16dc264c058dc06a1ca6925ea309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2856a85913a132655af0255c883ebf18841287f80a9383c2e55552a14578ba"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "gpatch"

  uses_from_macos "unzip"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--with-vendored-deps", "--with-mccs"
    system "make"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh" => "opam"
    zsh_completion.install "src/state/shellscripts/complete.zsh" => "_opam"
  end

  def caveats
    <<~EOS
      OPAM uses ~/.opam by default for its package database, so you need to
      initialize it first by running:

      $ opam init
    EOS
  end

  test do
    system bin/"opam", "init", "--auto-setup", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end
