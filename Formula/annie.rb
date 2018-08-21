class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.15.tar.gz"
  sha256 "73e26dd5ba0ed1d767d79d0d7f9f0182cf3443585ea6f858afb964df6d79a1b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "f85c2c442b61a9b12165da7a0e76fd25dbf89faa64f319ff9af9ad6bcedf2f71" => :mojave
    sha256 "dea0b250b89b7dcbf0379bf6a2490c57ec4ff4e664e079fbf1de5fc71a92195e" => :high_sierra
    sha256 "32ede78f2795233ee1b847b0d70ae1acced51df86b509e71fccbb9bde760d0f4" => :sierra
    sha256 "afca601091c3d5f3569dced32371a5961ad64461066d859346dc137ad46f7e32" => :el_capitan
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
