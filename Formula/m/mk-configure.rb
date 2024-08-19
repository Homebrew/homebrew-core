class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.39.4/mk-configure-0.39.4.tar.gz"
  sha256 "30a8bd63ee3f4f2ec3eee92b2ef9b05de87d20c683dd2d89f579886ced282896"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6065d1f75ff6915e234894c8589fdb00e0746d1509b1b637139e30b3f0c90206"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c580e6d6d3a7aca6e343c57e05c8885828118b4b5461ec91373beff2bb9658"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb73671d43cf77e56fc62d67cba295d5d9c1a6f45e904b318747bdc8a09b5db7"
    sha256 cellar: :any_skip_relocation, sonoma:         "75a985eba5492ce875f632251fd6ab91dff419e83f5e83542ea8e3dbbbfc950c"
    sha256 cellar: :any_skip_relocation, ventura:        "524a1702703d3d3fd033ffcc2ee6f2af82a3188b3ec87dda8a5dafedaae96136"
    sha256 cellar: :any_skip_relocation, monterey:       "a0aa4d28ce7a935d97c2f86a44c86e364b8b942f75709c16be7f0f539e2de820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e3fab98b769718b4717f4e04cfb57e3dfb157dee8fb6b5d5aeef0ed042902d"
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system bin/"mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
