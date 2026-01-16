class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.5.0/opam-full-2.5.0.tar.gz"
  sha256 "25fb98f962c4227c1261e142afc68a416778e6e819600bd5ee3ec4a18ae1e238"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49fa1631fb9dc7f680166f185f095d1eeedd84f30c34a363b9a57a86b286ab91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a499ecffcda3cbd6264b6d110e54d632544fae0d80ef106d81e9328ca0bbc9be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13e3540dd831e33ecb61be42da177cd9a7cd815f2e2fe90cf3ddbd38dfaf2dfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "aebc9646975f09d68083d69eddf58221fa8e0bb221958b67fecbb6b9ce95e8fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71866a75c2a3f2c6f87927e7d74b059d8f49d792a03968364583df919adec39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc029045abb424f08f33f54b9bf6a48e6ffad9bce02f05c4e3e93a5093146b4"
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
