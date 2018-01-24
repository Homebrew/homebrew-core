class Kirimori < Formula
  desc "Tool for managing vim plugin"
  homepage "https://github.com/syossan27/kirimori"
  url "https://github.com/syossan27/kirimori/archive/v0.0.3.tar.gz"
  sha256 "5f9a0f1b30f888137201b4ba4558ba7e633855a53d53b6058f386521838aee0f"
  head "https://github.com/syossan27/kirimori.git"

  depends_on "dep" => :build
  depends_on "go" => :build

  bottle :unneeded

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/syossan27/kirimori").install buildpath.children
    cd "src/github.com/syossan27/kirimori" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"kirimori"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/kirimori", "--version"
  end
end
