class Elvish < Formula
  desc "Novel UNIX shell written in Go"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.9.tar.gz"
  sha256 "41aed14f500813c884a0a8b6c4ebbcdf233b2d139f1d10cea697d597007f1698"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a36df07bafd28ecb996e46d7d5853257d509544c455b7853c2e4cd3a219f844" => :sierra
    sha256 "ce99b7ebda92359ba19ad392effcb1f51af19d5f422337ee90f06f6d2a1a9ce7" => :el_capitan
    sha256 "206c2c9c2324ac1167e836f06688684d3418db1023575ad1ec036ecba4aa3f22" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-o", bin/"elvish"
    end
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
