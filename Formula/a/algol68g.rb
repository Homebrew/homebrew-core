class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.14.tar.gz"
  sha256 "b88cbcac88548e8862409fcae44a6bb082125cc031d70dbb237706a3ff47f569"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "8da3e482e79ee7e61157578716bd5a1079adbc50a693a1ab9ca5b9e8a875c428"
    sha256 arm64_sonoma:  "a1faeb97e6a316b8bf4e54513fe93504cd036990b3e4c144d82430fd19ba0f03"
    sha256 arm64_ventura: "00e86e6a1049d307c35c2f129680bbf2172ee4aede3ef35ae90b50d236fb2843"
    sha256 sonoma:        "3bb454cf07b1aaaa4910c9833ac65f295c7fc06990b5ed1c887bb8c5515915ab"
    sha256 ventura:       "e9e8041ff2fb6786a0def289a776a2b159f4bf6285105f3e3432f3a03513a819"
    sha256 arm64_linux:   "244c2ac6c5998c1216ca18848b2d16a1bad8d1d42a3e93752bc9aa6d3a5d251c"
    sha256 x86_64_linux:  "47a93c8a312a2bfe6c57b98d13e155b0fa0eab4fa8e48167ef0b4b0664844c70"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
