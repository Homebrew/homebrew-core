class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.5.1/opam-full-2.5.1.tar.gz"
  sha256 "48c5bfaf5f5c4048cc5f40025de7385f5bad3a8269756216cd6dd2f2150033ed"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ffbf7f241b17f60038e8b997f136aa818ec77ee5ecb855445cc723f6d112834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a102ff25064c45d9d18566307acec0317c06019c0a7cf672a635afeb7a0bab5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58dee4dadacafdbc36f8d2db56d95f350a59ac89bcff75213406394215af45b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e59be521f2ead04874aa787b4984c8adb4af62736b25c5d0bbe0f7d3873893f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca2f8f0aeee21bb39fea9128b741e15424645156fb726edfa7afccbab9fb0c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05e4e66f31665ef1fcf0cec5e6853b58849d56585dec45d734b1e27e45d1c0c6"
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
