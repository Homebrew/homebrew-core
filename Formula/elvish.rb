class Elvish < Formula
  desc "Novel UNIX shell written in Go"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.4.tar.gz"
  sha256 "05c32183462b0e63c832f1b0481ce79c4c6a289c14fe670b4400f47e349e2851"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fb11ca99a3e97bd042b7b560a7579795c49c2186578e6eef12c81b3560af3aa" => :el_capitan
    sha256 "0c11cb7e7a4adab892b2aaa94639aac35e9be7a48bba45e69e6354c3da470b49" => :yosemite
    sha256 "c252a2f6485139885943487e40baf406609943f26959b85037aa1cc8b8f7b959" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves").mkpath
    ln_sf buildpath, buildpath/"src/github.com/elves/elvish"
    system "go", "build", "-o", bin/"elvish"
    system "make", "-C", "src/github.com/elves/elvish", "stub"
    bin.install "bin/elvish-stub"
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
