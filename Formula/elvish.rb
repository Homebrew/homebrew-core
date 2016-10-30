class Elvish < Formula
  desc "Novel UNIX shell written in Go"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.4.tar.gz"
  sha256 "05c32183462b0e63c832f1b0481ce79c4c6a289c14fe670b4400f47e349e2851"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55dc1e0f37ce67ce34ea22c145aff8056b3073a6aa3b8c3c39c7e56a1112812c" => :sierra
    sha256 "10fc6abb091014f7f7b77333303bcfc2b3d8b51033da9c608ea326957e1467a8" => :el_capitan
    sha256 "96db9dbc110145a8384838513f8db2258ed3f836a2ddbe34f5f8fc7d9092df71" => :yosemite
    sha256 "b3f5e6e46c0c94ad034a27c36da089e31b5960accc5136ed2f5f5c8ffa54e88d" => :mavericks
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
