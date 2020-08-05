class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.7/opam-full-2.0.7.tar.gz"
  sha256 "9c0dac1094ed624158fff13000cdfa8edbc96798d32b9fab40b0b5330f9490a2"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f159a779ee6521c95c06b382fbea72bd1cedf6463d9be8bc85f5cfac4ef16b0d" => :catalina
    sha256 "fec93e54a1a635c7d2b5ca4acfbd051665a606f6760b5336b846b23ca8663e23" => :mojave
    sha256 "5fef1c5aca812af337373a34b9a97e2f0bd7bf3f22a36c3d184af73a4c2ea7f7" => :high_sierra
  end

  depends_on "ocaml" => [:build, :test]

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
