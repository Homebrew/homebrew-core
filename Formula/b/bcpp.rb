class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20250914.tgz"
  sha256 "8d2a0f6255243c7f422cbc8d9d65bb381cc6559879df967ba2838ac7d267be3f"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa74cdc2fb3f1809b90239f1e60363605cb9d5fc76bded0ea406d6e6920e1bdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25716040eca8bdd532b128d8f285d5eaea77d8522a893ede0a59c69515a95b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e169551e3a3120dc6966df837814802d00a8a6d1c799b40226ff72c2bfd79b46"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6d74b99d7963c3f7403a8bd3991cbcccebf0fa2da16672ad912ef6857055a3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a1a406681f95c80d946ca3155ea3cea7397a119634746b2d873b7520aa1ba4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b501371fb124bd5814589d0e6f3dd850221ccb40e0e4b4d3fc41b72fcec32c6"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<~EOS
          test
             test
      test
            test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_path_exists testpath/"test.txt.orig"
    assert_path_exists testpath/"test.txt"
  end
end
