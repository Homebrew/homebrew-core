class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_3.0.03/E.tgz"
  sha256 "712e7351ed8df4a77dbb36cda5e06dbcb6e050dd1cdcdded19c61cccadcab1d4"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/"
    regex(%r{href=.*?V?[._-]?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c04d920a12edca6eb8186770be2bef1d988faefa503ac57df6521c99d8800c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20985db61ba1e208c434210b07669486be1d2ac01e3b14350e349e6c5b72f244"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35ca6ac6e9ac816656c337e0eeceecfac76c9fc47d79932390c4594eacc4334a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fedf87e4fb9336f498247780c0a7c00cf56aa4343801cd213b1bff0901ae35c"
    sha256 cellar: :any_skip_relocation, ventura:        "2f9ddc53ee410fa4129b07a670044a990e4533be20d5f4c880fc17d49c890c37"
    sha256 cellar: :any_skip_relocation, monterey:       "b565a55ccd9d7aa4f1fb75806793c5997bcff60ce3609c68777889d32a41abb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574f0ff1d3927ce7b32d74c917c7af57d242d76495f914fa7dda4bb4fe1582d0"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end
