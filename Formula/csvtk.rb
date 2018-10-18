class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit"
  homepage "https://github.com/shenwei356/csvtk"
  url "https://github.com/shenwei356/csvtk.git",
      :tag => "v0.15.0",
      :revision => "087da1e2375f8acbccabe0239158b8900dcb955c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e40e4b5b75c73411f6ab74bea028f72f25f8b788eadf032f0f5cfed03baefae" => :mojave
    sha256 "37343e978d4035fa9b2881c038748ec4704bf8a57308c59e64592dd404166e36" => :high_sierra
    sha256 "d269ec8f0e492e2a9c7804ca2cc6d9211a9be7c3dfbb0daaab19c5b14bef5b24" => :sierra
    sha256 "e36259af15ec8cf6546b1f7d99a105efb9a30c198f549a67964417e31892fe97" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/shenwei356/csvtk").install buildpath.children
    cd "src/github.com/shenwei356/csvtk/csvtk" do
      system "go", "build", "-o", bin/"csvtk"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "0.15.0", shell_output("#{bin}/csvtk 2>&1")
  end
end 
