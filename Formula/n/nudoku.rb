class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/refs/tags/8.0.1.tar.gz"
  sha256 "4e8a35950b7b7ce1e49f9457a8aceffbd21fb2b34aa8386847a7a158a2cab551"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ad5f899cccffcae1ea64632d93816bd52e1ec79346e96c30aa5d86d352a84435"
    sha256 cellar: :any, arm64_sequoia: "16659060412088ccd52223b102d5bf9b9fb7be3d8eb4d35ea2743ff0c8a26426"
    sha256 cellar: :any, arm64_sonoma:  "b21ca3819fb5cdae160612d5ca559816a93c250f57fc0f0acdf020a6a7d18078"
    sha256 cellar: :any, sonoma:        "430ec8b566d0da6670537a5c9b98be6317ef5fbbe4ed9c29aed54137b0f2660f"
    sha256               arm64_linux:   "d417c25d0b62c00b32250c64a4d930568588eab0afe2449ce6afc558cee1b4a3"
    sha256               x86_64_linux:  "2b5a3aae3e9dd97abdad33306c35278e3e9bfdf59d5f549644c2b64cb9f58ca1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--enable-cairo",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
