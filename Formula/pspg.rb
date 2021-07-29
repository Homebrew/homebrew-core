class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.3.0.tar.gz"
  sha256 "8ed30fea8e06f65d29ce4362d1b57e43c75363d46fe23de442d91eaf7a27602d"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e2d1ada92bc716d520dc424b1f9d9a383b25b718a9784321e501bed88c9a9e65"
    sha256 cellar: :any,                 big_sur:       "ecdbd33fd9e06ee6ce75649ca49f99c4b07d0a22a57361152eba088f05514ec5"
    sha256 cellar: :any,                 catalina:      "22bc1135aaad5e47c5262b035846325d9b8c91d370873388ca8ee79b7e84acdd"
    sha256 cellar: :any,                 mojave:        "6869cc0e1eca40197ff20ac624c83e7d8068c75716c6e4dc1fd59bbebcdc11b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "767a479a758869d7a085189eb459f9c259d386c4a2b08e3e0842f33505639d51"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
