class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.015.tar.gz"
  sha256 "7c8e7ea1732351a044f4c6568629f3bb91ca40cd4937736dc53b074495b1a7f5"
  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0e79f8dac4fdd9501fe421db7062fa0079a97cd2772a55a64ac5539b1b64d17" => :mojave
    sha256 "ced96a75c37a3f1676ddff1ed47b66c4d76e9200c656e18585ab83d0b3c9ef57" => :high_sierra
    sha256 "88cc0a307b4e6dc9ead44158859c647d3459f39cf841571f88c251a77ec57d10" => :sierra
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
