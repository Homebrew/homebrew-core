class Ad < Formula
  desc "Adaptable text editor inspired by vi, kakoune, and acme"
  homepage "https://github.com/sminez/ad"
  url "https://github.com/sminez/ad/archive/refs/tags/0.4.0.tar.gz"
  sha256 "e35cf1030bc24bf336066fcd367e8a022d097357b896cb316183993951d4ffb8"
  license "MIT"
  head "https://github.com/sminez/ad.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b81b1437ce420a38ce5e3f64127fa25588ff01a5b692c4aab5ce21e59bf39a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f047551147285fad0d3feede1fa574583925fd2aa0754b9effef1fac774ec4f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e29c07c761c4d51b6e08ec9fc61e6904d6dee0640740f9817c29ebcaa44b8d27"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c8c34033947dcbc878f8bc02e9b2823645f552868178710b7cb8a6dcb846139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2defe85dcaa26415d025f3b86cae81345a537297d4c1cc267e305af9d81531a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84bed0130762a14769d5cbe2be6ed3ae399d060747613c1bb8f3aad144225bdd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man.install buildpath/"docs/man/ad.1"
  end

  test do
    # ad is a gui application
    assert_match "ad v#{version}", shell_output("#{bin}/ad --version").strip

    # test scripts
    (testpath/"test.txt").write <<~TXT
      Hello, World!
      Goodbye, World!
      hello, John!
      Hi, Alex!
    TXT

    (testpath/"hello.ad").write <<~AD
      ,
      x/[Hh]ello, (.*)!/
      p/{1}\\n/
    AD

    assert_match "World\nJohn\n", shell_output("#{bin}/ad -f #{testpath}/hello.ad #{testpath}/test.txt")
  end
end
