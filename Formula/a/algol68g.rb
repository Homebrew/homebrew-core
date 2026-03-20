class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.14.tar.gz"
  sha256 "2d68874c574d4c20bff13da30b97a79bc3736fee1a93339892e96d7dc1484e96"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c1d6eb9ae230c5b793e65bae535c5f4d58aaf07261a06808d3de3b5eee40bdd3"
    sha256 arm64_sequoia: "21c9e8ded15b6dfbd2581bf87405b3063b8b9ef9a55fab82809757d45f86cec2"
    sha256 arm64_sonoma:  "7bf26a1503c837a74f0c680faeae6082e0a9be5ea8674e0a5c49b880562937e8"
    sha256 sonoma:        "83c113883cf9f08bd33a4a41c093cd8b993475d6fb118af5e841ab2de1e2d5a3"
    sha256 arm64_linux:   "b45bc35d7597a0c1d610f4c856aa51e636bf60a85ae6e90b85a5ccae84e0eb35"
    sha256 x86_64_linux:  "cccfdcf51664490a12614dc1fc6b411c4029ce9db049b61bf8a94177890d65b8"
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
