class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.5.2/opam-full-2.5.2.tar.gz"
  sha256 "b3623809567f19ed6b5d679b8c7bbc0bdec9418bff4a875ff0799d446d8555c3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0b6bfce1051e49930f546f98c2fa091b139693b9928a2430c02bb23dd05d42d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec2877603b2b08aa53acd6323e2b13a5dce214f43da6469897f7b9397b5b65f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b2dfe20800aee2c5c69ffee27e2221ed3b30cba4508317da0f70117f50070b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "35a4afd97a9951ca0dc3dcf65e677d54936649fe43c2107b7ad2bc4df755227c"
    sha256 cellar: :any,                 arm64_linux:   "01eae40001fd0a8f6e3346758d2de6b4027bb838f93c7c5470b8d2cc08adef13"
    sha256 cellar: :any,                 x86_64_linux:  "ad75dafb8b3159be00ccf60cb5e6474939610503e9b81847eaa00f005adac516"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "rsync" # macOS's openrsync won't work (see https://github.com/ocaml/opam/issues/6628)

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
    system bin/"opam", "init", "--auto-setup", "--compiler=ocaml-system", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end
