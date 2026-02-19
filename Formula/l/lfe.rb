class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "https://lfe.io/"
  url "https://github.com/lfe/lfe/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "5c9de979c64de245ac3ae2f9694559a116b538ca7d18bb3ef07716e0e3a696f3"
  license "Apache-2.0"
  head "https://github.com/lfe/lfe.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5158c69b0a420798bd81ded50265abbc00cb0da90ad7f237c3e266312092304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aee8b425cbd76428a038e8d9d1a074c2e7c3f9c2944673fd9267c77e8d154fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c9d4f4a7d9ba6a61e9affb3d8ec94161ac3411c14da462879c348fa59859d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e257ff304896fce1182b709f35b56112c28eba8e43ac6a149725b42917a9bab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed17738b499109261be99c6cd273acf572c4b4a2ea05828aed6ebeaa076f30ec"
    sha256 cellar: :any_skip_relocation, ventura:       "9e047588e594f9c78f18d8be1966a1987639f98d07e57dcb47f0b2bde46e8199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8d62b19bbae7750b68d0c2a91bfb0e6c478e66cd2a5c889048d355bcfeed117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aceec9c08993a9e551d5b1657a2162afae1f8a248054e6eba1fc4eb5781386c"
  end

  depends_on "emacs" => :build
  depends_on "erlang"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"

    libexec.install "bin", "ebin"
    bin.install_symlink (libexec/"bin").children
    pkgshare.install "dev", "examples", "test"
    doc.install Pathname.glob("doc/*.txt")
    elisp.install Pathname.glob("emacs/*.elc")
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
