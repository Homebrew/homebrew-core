class Httplab < Formula
  desc "Interactive Web Server"
  homepage "https://github.com/gchaincl/httplab"
  url "https://github.com/gchaincl/httplab/archive/v0.2.1.tar.gz"
  sha256 "6a4a7b8fecd34cb95a8281d0f1f4fafdd78b23121e34ec64c7d294559e9ff207"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gchaincl/httplab").install buildpath.children
    cd "src/github.com/gchaincl/httplab" do
      system "go", "build", "-o", bin/"httplab"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/httplab", "-version"
  end
end
