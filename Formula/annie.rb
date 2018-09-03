class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.20.tar.gz"
  sha256 "73a3a87e87de560464432627f05298365ae6e60835ccd568cceb349f09e480d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "918632a77ba1054afcfc03bcdc0b83164f057dc51f5ac6a8847094daea3af15e" => :mojave
    sha256 "b869678d747073bb218306f9247fd89893b1cff6673846d83f1b2bfd0d042a1c" => :high_sierra
    sha256 "350dd46afd736ec116bb5b7090ea2236c93c455699e1d98ceaa8a23b43cfe360" => :sierra
    sha256 "f38b61b40e99f78ed9b722de55b86c75cd4056710afef8521e728dbec55f8ba8" => :el_capitan
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
