class Gnuski < Formula
  desc "Open source clone of Skifree"
  homepage "https://gnuski.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gnuski/gnuski/gnuski-0.3/gnuski-0.3.tar.gz"
  sha256 "1b629bd29dd6ad362b56055ccdb4c7ad462ff39d7a0deb915753c2096f5f959d"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f2302fda0228835c20f3158b0f0a8500c85d70d7fe58d698133da7ea792be282"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fa3056f32083991e84354204c559e07b61f5b79b0a24ca13cd655da45815b5d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b235ad7ef6b4326f8e170d14a29fe29b96c18bf2cec583bfac6e88cc3ff0f7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da56e306a753eeae75d10c177c42a17698bdb41e0cfb9487f98af4347353510"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ffb1f95f60f2e9244ccd431e72aab1fd4b44b8b7cf684efab6965d5540c853d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82abb34deac302a464e7c664a3dcf0726f1d0f8ee03586b195e3449a2c83d43"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9b89435f33712b5ed56358a193772deec06207b0c8808c2357ef913da5fad8d"
    sha256 cellar: :any_skip_relocation, ventura:        "2e85d7ff425c969c3ec59ac17c7638424a2533e2064478f782a3ecf3a7d8abbb"
    sha256 cellar: :any_skip_relocation, monterey:       "313b0cefe9c2c2ffa45f1bee439feb5a28ca2c3fcce32bfa566534f6c3cad725"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ae8c77ab5fed3e5f85be1c411cc631099d219bd49ddb3a35f527da27894b880"
    sha256 cellar: :any_skip_relocation, catalina:       "7c58085b5ceb98168c728003d484e08410c837bde9b044ed5a5fa6f26796d9ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "29dd19f42af62052c1b1e543beac12ef5a3f04a6266dbddc0ca6ae5432835ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ecc1577888f0186d9880b9048a0fa9e4bdf931d3f2710adf807419f7a64310"
  end

  uses_from_macos "ncurses"

  def install
    # https://sourceforge.net/p/gnuski/patches/2/
    inreplace "objects.h", "#endif", "void setupColors ();\n#endif"
    system "make"
    bin.install "gnuski"
  end
end
