class Elvish < Formula
  desc "Novel UNIX shell written in Go"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.9.tar.gz"
  sha256 "41aed14f500813c884a0a8b6c4ebbcdf233b2d139f1d10cea697d597007f1698"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3cd7c20e64d361927b6050c79aea1ac9f3266073706eda12870f1b5c7d774792" => :sierra
    sha256 "52d43c85b16a7785b95b0d6f01e54d3263c10f19af4222b59ecb37d7bed06a63" => :el_capitan
    sha256 "5bb8dda1b2d803843a137d612fac32a6c7ebf11cdd3c793a23225d91bcb71a6a" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-o", bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
