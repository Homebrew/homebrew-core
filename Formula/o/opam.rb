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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "363a8906100e191e775f1b199cfcbd455b233a5a8de4ab615621d65c97a516cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df4e2cce2592afe76caa3c865e42dbebd2822c99c5260e35fe1b64b1656cb754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "389c2cf95ce32cf161fa1f153be19b3cd39b9fbe8772ad0ef32c06e7c1cfaab7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0ac573a729732ded9d5b5a639e0196492e85c0b9b3557a0a877dd8ed0e5d7e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d9e0142f44bd6417f011c05151188dc108f518f44f7ec232ea6de0a45dddd81"
    sha256 cellar: :any_skip_relocation, ventura:       "78222428cbf1e079456bce1f45004de794ca637247b634a44562768005e8450e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbdad97c898c128202b6e69ae2fa891538fc251f25ac26936d8d64e08b311bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1137fc30211adcb4f32b57524619adf67c49b85bea082fe31930e83ac2176f"
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
