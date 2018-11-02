class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.015.tar.gz"
  sha256 "7c8e7ea1732351a044f4c6568629f3bb91ca40cd4937736dc53b074495b1a7f5"
  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82031c2c21578c6355de9c2ee58aa27b22f0864a7312fe77f10f4fde879be5e2" => :mojave
    sha256 "73adefeb74c5ca7c7207ed2b8dda70e74c95dcdac1cff4f6fdada49f4edf65a1" => :high_sierra
    sha256 "cc492608bbfbf2f12a6ad424de9927e8d25038fb9b40d1058383656c09f38f60" => :sierra
    sha256 "9e1449cd025d40e6669cfc0941f81c857de87b436fe48138b3b2c7db33754162" => :el_capitan
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
