class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.6.1/opam-full-2.6.1.tar.gz"
  sha256 "ebbaffa4192e69d612d2c1a5fc5a15b32730322d7e34bc4456ad4076bb987007"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65aef9939bb8a7d25547e9d5997c6c02026e6bcec2e85b39560a690a64ebd8c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82d27fc543dfa4ba9c8724432511b325198626d1f314e4915e2d129d24598116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0588e2f9616926a171ba59287de00181b3a65aed3e5d185e97fa50ba26c7444"
    sha256 cellar: :any,                 arm64_linux:       "dba1c12e1d41519f1e5ca1254a577959b7b802803ebd2c2391c2e93416ca26dc"
    sha256 cellar: :any,                 x86_64_linux:      "81d90ec454f53c9dee1efb34af235bb1cb81659e4c7cfdcbd4b96cace23e1fcc"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "rsync" # macOS's openrsync won't work (see https://github.com/ocaml/opam/issues/6628)

  uses_from_macos "unzip"

  allow_network_access! :test

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
