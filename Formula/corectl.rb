class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.5.9.tar.gz"
  sha256 "3d8ce542ca5cc5f68dfeaa7fe41b9b8a50f9afdc8ec60b7b55386bc6519decae"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "677d2b444848055406c3f5742cfe02427b8699777b85d16f75a1460ff48f95b4" => :el_capitan
    sha256 "1a52b543904ed22234645643bb9add1c9860c0141345aa8f091df7c245c9ec17" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/TheNewNormal/#{name}"
    path.install Dir["*"]

    args = []
    args << "VERSION=#{version}" if build.stable?

    cd path do
      system "make", "corectl", *args
      system "make", "documentation/man"
      bin.install "corectl"
      man1.install Dir["documentation/man/*.1"]
      share.install "cloud-init", "profiles"
    end
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/corectl version"))
  end
end
