class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "https://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.6.1.tar.gz"
  sha256 "6dd5511b92b64df115b358c064e7701b350b343f30711232a8d74c6274c962a5"
  head "https://github.com/rwos/gti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "446f9add483258a77d510681e375d5c52e29518e9e1b95f6f0809cbca6cc4b4f" => :catalina
    sha256 "8e648f9d219c21b6cb8477ec7902c059c936b907bd5d8cae49519b8f22533b41" => :mojave
    sha256 "125203670f0704594bf4a1779feab364ea04ea7d6cff9a83205628ea85485ac4" => :high_sierra
    sha256 "9918086fee473669a1ec8ea62eb3b30c0969334790a9c6ba549c7d95e79b6a66" => :sierra
    sha256 "a3b6c788ea2f773a73b7ff2e04e6a8c44aabe6e090c52b668dfb0c7116b9cae5" => :el_capitan
    sha256 "0f1865eb7cac49f0ac857718196b70c896e70a636d4443b523e0eca7fe1f7ab9" => :yosemite
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
