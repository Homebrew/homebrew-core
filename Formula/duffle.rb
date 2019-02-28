class Duffle < Formula
  desc "Command-line to install and manage CNAB bundles"
  homepage "https://duffle.sh"
  url "https://github.com/deislabs/duffle/archive/0.1.0-ralpha.5+englishrose.tar.gz"
  sha256 "81e31da0fddfdcff12d95a5711a2a6f0e343eecf523829b21063a3edef62a9d7"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/deislabs/duffle").install buildpath.children

    cd "src/github.com/deislabs/duffle" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "./bin/duffle"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/duffle", "init"
  end
end
