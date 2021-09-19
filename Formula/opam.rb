class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.0/opam-full-2.1.0.tar.gz"
  sha256 "6102131a9b65536b713efba7f5498acb3802ae15fec3171cc2c98427cfc3926f"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "123479f1d339a12438b69a3989fe7a071afb27199e0fc43c03dd48a931a16d87"
    sha256 cellar: :any_skip_relocation, big_sur:       "c7f5790fcae38c515645b01d5220bc72a871d0757826b0b0ef00f15394779edc"
    sha256 cellar: :any_skip_relocation, catalina:      "de234d72d049fa6451a558ea84dec3361a16119a7df5184d9d683e59ddd1ca21"
    sha256 cellar: :any_skip_relocation, mojave:        "d3c5435c5af63e34d72b9fc8bc73087c973f4dc8273d8f5f6567608fea1a4284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a7773d2d7d44a490c0c98e92e4c05f6605ca8e7ecda516e879be221abcf3f1"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "gpatch"

  uses_from_macos "unzip"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "lib-ext"
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
    system bin/"opam", "init", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end
