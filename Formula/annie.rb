class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.6.tar.gz"
  sha256 "ffe41fa0a87636fc0dc4c419a273be26e6272b8658d27994f4aff7374ebb604d"

  bottle do
    cellar :any_skip_relocation
    sha256 "92cbbeed5f83219324c4c6be1da36ce11a3ba4b291be7d05848f9e6e1ee34b33" => :high_sierra
    sha256 "1f43be13d37e7ae1c10e3eba6a8eb8774de054234cc9db5fa51a31fc6a81f2db" => :sierra
    sha256 "f6f1233ee668fc48f12e50683087e0a1fcc97b1a7610142092e753472f91d5be" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/iawia002/annie").install buildpath.children
    cd "src/github.com/iawia002/annie" do
      system "go", "build", "-o", bin/"annie"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
