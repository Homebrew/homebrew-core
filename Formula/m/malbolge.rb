class Malbolge < Formula
  desc "Deliberately difficult to program esoteric programming language"
  homepage "https://esoteric.sange.fi/orphaned/malbolge/README.txt"
  url "https://esoteric.sange.fi/orphaned/malbolge/malbolge.c"
  version "0.1.0"
  sha256 "ca3b4f321bc3273195eb29eee7ee2002031b057c2bf0c8d7a4f7b6e5b3f648c0"
  license :public_domain

  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9200d693051f33a58ff8e68f12928364d6653f3454308cac97d449cf98bcdfd7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ed3ec05cff2e43fe1fc3b7f5f4f89a7fa3237500deb29d9b9d430483a6872f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd5f8220806eaf3c9b7095ccf6d1471026e86e6970ba04384e55d999ec986597"
    sha256 cellar: :any,                 arm64_linux:       "fea2683e7e1da4731305b5185674c59c9566bfd4de6715faf6a5354dacbcf6b7"
    sha256 cellar: :any,                 x86_64_linux:      "5c7fcd96f09124aa07f32b21e3edf807ee345d383edb50a3c66ba8e54cecb46e"
  end

  patch :DATA

  deny_network_access!

  def install
    system ENV.cxx, "malbolge.c", "-o", "malbolge"
    bin.install "malbolge"
  end

  test do
    (testpath/"hello.mb").write <<~EOS
      (=<`#9]~6ZY32Vx/4Rs+0No-&Jk)"Fh}|Bcy?`=*z]Kw%oG4UUS0/@-ejc(:'8dc
    EOS
    assert_equal "Hello World!", shell_output("#{bin}/malbolge hello.mb")

    (testpath/"bad.mb").write "aaaa\n"
    assert_match "invalid character in source file", shell_output("#{bin}/malbolge bad.mb 2>&1", 1)
  end
end

__END__
--- /malbolge.c
+++ /malbolge.c
25d24
< #include <malloc.h>
