class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-3.1.tar.gz"
  sha256 "4693d195778c09a8e4b0fd3ec6790efcc7b4887e922d8f417bca7c8fe214e2aa"

  livecheck do
    url "https://eradman.com/ephemeralpg/code/"
    regex(/href=.*?ephemeralpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f61b619659f12955247d431e3c93ff71c3c851833f1b25c00f53c919a1828b12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa5007de85a1480bfa6ccbbd8b82040ec9d70084cb9a95d33e0a0fcbd406a3d8"
    sha256 cellar: :any_skip_relocation, monterey:       "48d7bf38bcc5097d0f197ae89f111ea58f5152356b6c1c8e1d55a03a2943bdd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "30816c4f32b0ba3a38e436626a9d59f74f1f655e51c74616470908f56ea86720"
    sha256 cellar: :any_skip_relocation, catalina:       "0ebc56c6b29ac11305a81437a0c8aa5e6b31f9ab58daad8b695e3560870f09a3"
    sha256 cellar: :any_skip_relocation, mojave:         "56d56bf1bac23530fcdeb3d9b0f2161cac9ae606fdb19d61a08617a825cf31a6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ff9f13d039de049edbc0b9c085e3d49b263fe1d1a2c0e1f4c8184f121e435c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cfc5ecbe7ff3fd431e659143dc39b0cf7c81e5cde19fcbd0397ce6c2ab01edb"
  end

  depends_on "postgresql"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end
end
