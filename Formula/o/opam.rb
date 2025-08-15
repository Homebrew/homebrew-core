class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.4.1/opam-full-2.4.1.tar.gz"
  sha256 "c4d053029793c714e4e7340b1157428c0f90783585fb17f35158247a640467d9"
  license "LGPL-2.1-only"
  revision 1
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e44b50546eadb8dffec31ae55b5904176bc24509f2eab257555b62e03c3c231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "614581f51eaf7d33783c5034fd7a8929af3b9954532b5b5c6aeeab64bdefe48c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "337336308e954e3c0276614984d9cb725c0f12cbdd2c57f3d664f35db625e064"
    sha256 cellar: :any_skip_relocation, sonoma:        "03372b53426066e6aa31171013677e2f4f525b9addb8b56f7cb094be7aa5ad68"
    sha256 cellar: :any_skip_relocation, ventura:       "f76b7794e9318e63f54fa9005843c366717b35f78d710feadbea521dc90b11a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e30086e9c3082a15e0452269c8e7589e1fde7d5bdb3a2cbf089b935e9d20f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "455d8d1cc9aefb06a9e13a27f3ec8c0648d24081e9c81fee3fa2ffed62a58499"
  end

  depends_on "ocaml" => [:build, :test]

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
