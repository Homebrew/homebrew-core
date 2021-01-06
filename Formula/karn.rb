class Karn < Formula
  desc "Manage multiple Git identities"
  homepage "https://github.com/prydonius/karn"
  url "https://github.com/prydonius/karn/archive/v0.0.5.tar.gz"
  sha256 "bb3e6d93a4202cde22f8ea0767c994dfebd018fba1f4c1876bf9ab0e765aa45c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d6f89b8d10f4afb4e9b293940f79de15845105edc95372c5f208d6042abae3a" => :big_sur
    sha256 "dbe143cddeeb74fa8cbac57f8f28f9280ce6ba554fe00d02b44f68316a229710" => :catalina
    sha256 "3a353fc809699b904cdbc845138518fddabfac7250b22d68a47f9ecdd98de967" => :mojave
    sha256 "a837fd65265db402d67fda5ff5bb4337822d1efd945bee56f7a664e6bc67c343" => :high_sierra
    sha256 "0b29500ed8d75753402ea041190021d679624b739665b3a4d11df3d4a3100e59" => :sierra
    sha256 "bc217bf56d073ffabd11c81382387029aa09d216ef8060b3134a6190997ef0f5" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/karn/karn.go"
  end

  test do
    (testpath/".karn.yml").write <<~EOS
      ---
      #{testpath}:
        name: Homebrew Test
        email: test@brew.sh
    EOS
    system "git", "init"
    system "git", "config", "--global", "user.name", "Test"
    system "git", "config", "--global", "user.email", "test@test.com"
    system "#{bin}/karn", "update"
  end
end
