class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "https://olivier.sessink.nl/jailkit/"
  url "https://olivier.sessink.nl/jailkit/jailkit-2.22.tar.bz2"
  sha256 "985564721366eaf5c6482dd17e91647d21e70b4c9803c74847d649d8c8c2bbcf"

  livecheck do
    url :homepage
    regex(/href=.*?jailkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e7430502c139654178b1f55f3fcbbd18f199017431ac753497f422c6e0e93d91"
    sha256 big_sur:       "b11a5e400e785f8a6e8e247ddcf806757fe6c096400e07f6c30067f0a09cb6c9"
    sha256 catalina:      "a7962e3d4012d9d4253344b3531e1f29fddf56ebc0f0c8b4949e2619765916ee"
    sha256 mojave:        "f698601ea035d4673f85367be42250bc45c5865e3fbc633062e63fd087ad5f28"
    sha256 x86_64_linux:  "35570cd4d15f648cd41f9d1144037da27806bd8b4ab0c18a15696a3d26cb5dcd"
  end

  depends_on "python@3.9"

  def install
    ENV["PYTHONINTERPRETER"] = Formula["python@3.9"].opt_bin/"python3"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
