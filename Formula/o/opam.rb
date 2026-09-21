class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.6.0/opam-full-2.6.0.tar.gz"
  sha256 "eba7360253fd791eb9edaabe4848ea0c59b35da5f5f5dbaaff5eb68bf618ca08"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64e008ed35732d9de31138cdba6b55284f7be49083c0fb9b2f6ee73e99beef46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc0991b97991af5b4fed0a7b921331cdf29bc67d99faf103c052148f5194a7f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28fa94a50c705cc3ca101c4d73e52204ff81759360adb65b8b5af70e0d44c028"
    sha256 cellar: :any,                 arm64_linux:       "704129aab3e2831fb97806bfb2868d522b01b5120288006cc7933be85cf7231d"
    sha256 cellar: :any,                 x86_64_linux:      "f2d238664b9ab4989aa1160783a12322d64f184e55380765c4a343cb9e600974"
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
