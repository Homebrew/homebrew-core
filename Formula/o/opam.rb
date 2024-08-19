class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.2.0/opam-full-2.2.0-2.tar.gz"
  sha256 "459ed64e6643f05c677563a000e3baa05c76ce528064e9cb9ce6db49fff37c97"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4861e7c04a42f1ce597dee95261d0f1ef263dd57409d604c072f37b1130e572a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b062e1def8db669fb0d05e3bfe9010fa04ebeb2895c6f2654a455f23d3102a62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cea5f84d3ed7fd99664c98666abecf5e27bd9104ae74a96c2f5093da3e5ff517"
    sha256 cellar: :any_skip_relocation, sonoma:         "8132314391b563a60942b95154d9a29f7a477d9ae450c60a024e5bf1c4b84dad"
    sha256 cellar: :any_skip_relocation, ventura:        "42b105611a773cf59afa1045c98aade3901bdec7f5cde16817f254bc964c36bd"
    sha256 cellar: :any_skip_relocation, monterey:       "b4477723da457a57ac9e86f35c7bda82b53a56c34cc12250d6b0d70e89d45375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f67dea0d72da8b4b64e6c43407f297d617c981e01d09e7fa0ef40a0932edbb4"
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
