class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.10.1.tar.gz"
  sha256 "a1ba39076cc45b24a8763174978805fa93c8713641d0e1715e9ada7d1122ab49"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a99318970d2004834f9bb991a3a76ed1b29aefc58422b654f8ae447d18906e7a" => :high_sierra
    sha256 "c651330cab6b79ab5c0168a8e82b583940e8d75b19aa48f472be4ab1067e2d88" => :sierra
    sha256 "dc6cbed0466aa0acc45ee8467d073c4238574f425c7047f27ebc5b6b63f4b244" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-ldflags", "-X main.Version=#{version}", "-o", bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
