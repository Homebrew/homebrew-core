class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.013.tar.gz"
  sha256 "f76e14678f2da8547545c2702406e27983e0a72263ef629b3ee4db226b94f6ae"
  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ba3d3ef2da44dfae8f4c332873a3326b63ce4e6ea888d67603c61f3250fb5f42" => :high_sierra
    sha256 "b0f70b42422e2afe1f29b7384f915dce7a20abc0f22954e6f51c4afd8eeac614" => :sierra
    sha256 "28f5287ae40edf0e2694d881476abe4a7967b0a9f2e6a3299be49bec6b25f471" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/t3rm1n4l/megacmd").install buildpath.children
    cd "src/github.com/t3rm1n4l/megacmd" do
      system "go", "build", "-o", bin/"megacmd"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"megacmd", "--version"
  end
end
