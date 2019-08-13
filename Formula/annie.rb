class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.5.tar.gz"
  sha256 "69e0213c81b88838c01f93eb00ce68701ad36ba53301327965acb7a6b39bcc3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f82d6002b276f26400cf5ed555d8762e1461bf8d706b0223023c74aca35e13be" => :mojave
    sha256 "8270f3cd4df02c56dd4adcd9c6b9c3d9333748c50cc6fbd4d0dca6b9b3e8fb4a" => :high_sierra
    sha256 "55d00a242822d3819fc63991bcfe8116a37a7e5c502e5131ba82a7144a2a85f6" => :sierra
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
