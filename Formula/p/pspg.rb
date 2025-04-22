class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.8.tar.gz"
  sha256 "085847b76be2f26de10114bf34dfc498b690d0c7e5ff8617b5dd79717236408f"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8294ac40d63e9527e3cc44392ec0e02fb6e10c077bef4c2769e128cb088b38e0"
    sha256 cellar: :any,                 arm64_sonoma:  "ba036121d35759286ba838c2fb6e1eaf9b128788b47887ea6e6971f3d598d949"
    sha256 cellar: :any,                 arm64_ventura: "8b4c4f59ebd9aa94a002b3950f86174d128e91d8b453fdecf1f572b3861dc448"
    sha256 cellar: :any,                 sonoma:        "ca6de3abde45647473dffb940648489f6443ba3ca13f6422edbbc88b63edb5eb"
    sha256 cellar: :any,                 ventura:       "48e69d20062b472252b53695e29a34e3f2bba7246edae7c75875eee2b9b1f894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae0ad43b352850456bc587f38b6d235bfca11ffce1f9adc2eea8a989386cb1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef779b44b5acd71884e8af2c6947e3083c21f88e8263298d5b45beeec3f0ba71"
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
