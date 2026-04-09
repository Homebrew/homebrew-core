class Enca < Formula
  desc "Charset analyzer and converter"
  homepage "https://cihar.com/software/enca/"
  url "https://github.com/Project-OSS-Revival/enca/releases/download/1.21/enca-1.21.tar.xz"
  sha256 "8b24e8a3a84288733b78addd24afdea1a3a5e6c61dc0ca8ca1d3702e481bc5ed"
  license "GPL-2.0-only"
  head "https://github.com/Project-OSS-Revival/enca.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "6f6a06988c26f7bceecbf3e76066b15571b3266fba0e1d41293e06819de8712f"
    sha256 arm64_sequoia: "478ae91ea4e91813360d353e1b74065497d6d26f81bd77fd3b8ae89466168eb4"
    sha256 arm64_sonoma:  "7cebda3233985f2f377803b5005238d90e0ea138dc7f72f757ec14ff4a30e193"
    sha256 sonoma:        "1f570881b34f66ebf16c3e7ccb0985297ad3e88fece0ca639d07d4a87eb404e9"
    sha256 arm64_linux:   "6e960f169f476284e8e65a6a5de5cffa5b717e372b31e4db5f859a09600de2c4"
    sha256 x86_64_linux:  "50e7ce46effe269c43ed8352e67d5c8f785baa1e96b50796d02c5b10158de5a0"
  end

  def install
    ENV.append "LIBS", "-liconv" if OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    enca = "#{bin}/enca --language=none"
    assert_match "ASCII", pipe_output(enca, "Testing...")
    ucs2_text = pipe_output("#{enca} --convert-to=UTF-16", "Testing...")
    assert_match "UCS-2", pipe_output(enca, ucs2_text)
  end
end
