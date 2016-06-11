class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.5.10.tar.gz"
  sha256 "e7b86914316d00f161c92f2b0bc0beb2ce26486199057e0536b16e6d47e2b47a"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "b29a9318bc7cc62b0893fbdea0399be704db692d28ebed87bf8b584660807eae" => :el_capitan
    sha256 "d2d46384a817b0075df0d97610a10be3a5a1ba46a9e5ca228299ae3c242817f7" => :yosemite
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
