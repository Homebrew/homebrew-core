class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-island.net/archives/bcpp/bcpp-20261127.tgz"
  sha256 "a56d35dd952b6d1408836cd93aae908b59a66d7f382abdcab2b06c009d331982"
  license "MIT"

  livecheck do
    url "https://invisible-island.net/bcpp/CHANGES.html"
    regex(/id=.*?t(\d{6,8})["' >]/im)
  end

  bottle do
    manifest_sha256 "99eaee69f711fc5c85e4a92ccbae92415d1cc46409259bacbb3013024d35fc5b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff75f3120d4b93d670d389fdbb7448464a17a90f6bc4f3f63955034044cf034f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f70aa5beec975879de43088f6c936d55e25517e5a5de6160d7d94cfa2289617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a0dbed16ea5f6b78ed7590c07faf84e7a7f21d657bb512184a9c14c9ea8c899"
    sha256 cellar: :any,                 arm64_linux:       "d753dadfc0142f29ef23d83e6ab61046e8811b3e1080ad73718f44100315fd06"
    sha256 cellar: :any,                 x86_64_linux:      "8cd39b941b294f9654b4c52807ba941e177f70538420ac3ae0c6790ec99735d0"
  end

  deny_network_access!

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
