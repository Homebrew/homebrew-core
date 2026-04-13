class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.11.0.tar.gz"
  sha256 "2ec25100cd76c620deec2d61876db44091d80910a79bb783ebe336aeaa0eed74"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "589b4e02c09987a5a190f0068b2c554fb2b89a33b8be7e061f6e7a8a12a9965b"
    sha256 arm64_sequoia: "7cf73c7c0b03fc857a2d715c4e7026b5d3030421e21aaa1412c673e3351eab3a"
    sha256 arm64_sonoma:  "c112d674290cc526eb15b8e31c8eb68e19f65e25b1249726213bad5462b25118"
    sha256 sonoma:        "5f1cacca82582fba60be1bc4e23242766e2e76d052ebf38dceccb7441c72bd2b"
    sha256 arm64_linux:   "35176c8ff2532d8c812d1b2959f5d66453ac2b4aa35201da54a5a4aa0d072c9d"
    sha256 x86_64_linux:  "8b5c74f8df54773ae44117159f108d17bb57e8ee60e7d35b8c70f91271e9694c"
  end

  uses_from_macos "curl"
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
