class Malbolge < Formula
  desc "Deliberately difficult to program esoteric programming language"
  homepage "https://esoteric.sange.fi/orphaned/malbolge/README.txt"
  url "https://esoteric.sange.fi/orphaned/malbolge/malbolge.c"
  version "0.1.0"
  sha256 "ca3b4f321bc3273195eb29eee7ee2002031b057c2bf0c8d7a4f7b6e5b3f648c0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dbf31191633eab5119ca16eda4b541264a42261c5c7b7103e50446d1505dfc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e689895ba5a84f1d6b44eab314ef7b71111ad3a19e054fb1a0b73e81a43f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df9e2b8bc55e587840b6f51c5fcc09b7820f148daa34fcf19fd64e18dd6b8769"
    sha256 cellar: :any_skip_relocation, ventura:        "7c371b9845e7eb81eb6a9a9ed0611713d092e58b1a8e6e04f86c29656a6afaad"
    sha256 cellar: :any_skip_relocation, monterey:       "4a7325d76aaadf2cc7da73b26ef40bbbf3e36e26a915f9cca27beb1c742432c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d20423d7d367645816e29d674ea45b2efd683cf781428c79a7fb73abb15974f"
    sha256 cellar: :any_skip_relocation, catalina:       "fc544c2c918c4a4882cf3ea49b28d8e5fdec31637c8f8e4a33874229ac54d6b3"
    sha256 cellar: :any_skip_relocation, mojave:         "40942ff18c1bc85e171257e95516c3b2f20066971c81c6c773d5884285590216"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5499e81bdb3bb7c6d93f7087c1d79a632e1dc5909e279bb1d37eb93906ca8c20"
    sha256 cellar: :any_skip_relocation, sierra:         "4e4b604d3ce7e8ccc5933dd949b55e77bdd59d21f084b4183b950e9dd552f368"
    sha256 cellar: :any_skip_relocation, el_capitan:     "20f743a8bcb4085f5958e65a54bc20399de6894155ecd64dfc056431d93ec477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d562330170f412427bd1d214d7521b400c8dd5d198d27d86ff1c47cf60339322"
  end

  patch :DATA

  def install
    system ENV.cxx, "malbolge.c", "-o", "malbolge"
    bin.install "malbolge"
  end
end

__END__
--- /malbolge.c
+++ /malbolge.c
25d24
< #include <malloc.h>
