class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.9.tar.gz"
  sha256 "8b8450a4a0df67eb04fd6c9be027cafd0e6b57123896f63a5ab2983c79caa238"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e84f22a95321321571ad9f1aa0dac7a5c578ccc5ee5f83f044b6c7764fc5b060"
    sha256 arm64_sequoia: "67037a70b986bb98773a4703277d3830c3ddb2025fda54af544e1eba89a96dbb"
    sha256 arm64_sonoma:  "a6a7c5de2a7195ac68387baf06b3ace0d5e0de90230587716534e5a5be5f8751"
    sha256 sonoma:        "c1ec050e20edf8a2d8fedc53fa5af7901d4902350543d06c692179fcce61c89d"
    sha256 arm64_linux:   "083d39e66096e9938c6a6c68a8a3d603d01c280ca017b5c0f42acc9bc1b1b80a"
    sha256 x86_64_linux:  "f64c003f1c001866138d79061301829027db37a4ab689be9018156911b6ed954"
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
