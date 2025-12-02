class Malbolge < Formula
  desc "Deliberately difficult to program esoteric programming language"
  homepage "https://esoteric.sange.fi/orphaned/malbolge/README.txt"
  url "https://esoteric.sange.fi/orphaned/malbolge/malbolge.c"
  version "0.1.0"
  sha256 "ca3b4f321bc3273195eb29eee7ee2002031b057c2bf0c8d7a4f7b6e5b3f648c0"
  license :public_domain

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "362a0dfad34c731bc75b81aa45736406c2b65b3f5f3c73894acb952d7025ec6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a27217c73ffd65f6eeb9249e6120ec69dfbc0121bf2bd721d9270c9173f543e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21e3313bf2fc20b33e637016710d778140383e9dbc2a4e45b14a564ddb081d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dbf31191633eab5119ca16eda4b541264a42261c5c7b7103e50446d1505dfc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e689895ba5a84f1d6b44eab314ef7b71111ad3a19e054fb1a0b73e81a43f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df9e2b8bc55e587840b6f51c5fcc09b7820f148daa34fcf19fd64e18dd6b8769"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cdaf2b347f1cde3026c930c0b928dd07d48c11fd958487b26fcac0fe6032161"
    sha256 cellar: :any_skip_relocation, ventura:        "7c371b9845e7eb81eb6a9a9ed0611713d092e58b1a8e6e04f86c29656a6afaad"
    sha256 cellar: :any_skip_relocation, monterey:       "4a7325d76aaadf2cc7da73b26ef40bbbf3e36e26a915f9cca27beb1c742432c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d20423d7d367645816e29d674ea45b2efd683cf781428c79a7fb73abb15974f"
    sha256 cellar: :any_skip_relocation, catalina:       "fc544c2c918c4a4882cf3ea49b28d8e5fdec31637c8f8e4a33874229ac54d6b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fde58cf2cc3ca5bd14497c96ec0edd11c89f9570b0c8d8da7cc1ff52c927517e"
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
