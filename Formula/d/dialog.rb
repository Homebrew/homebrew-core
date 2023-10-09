class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20231002.tgz"
  sha256 "315640ab0719225d5cbcab130585c05f0791fcf073072a5fe9479969aa2b833b"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abb3e7a15a47cd3e1e27c3d8c9db1c35d931077a25a01405825e3f464b9d2e12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92dbd5cf6e09fbc364060428696bd128c3c0bad31d45a10e8d5918638c1b994f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66142033e4e1d62bd8312577b9e824964c7242ba2f5ad10ac08f320d0def9259"
    sha256 cellar: :any_skip_relocation, sonoma:         "e361e68c1a9d2f8c4b72d79d0f9cb813e86d9d25c09123ec11c6ed86e74dbd17"
    sha256 cellar: :any_skip_relocation, ventura:        "6622f148d643c71339086d1a30e11c387ba3b0a3c007993b8c97fbe97f4140f9"
    sha256 cellar: :any_skip_relocation, monterey:       "b8d3ce6a999b385c726f34a6dbbd7c85dd9a1d842b5866921a8d63d69cfca17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ceae6488044f204f40d316b1b752e1194988f330258bffeff3124c4f11ef19"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
