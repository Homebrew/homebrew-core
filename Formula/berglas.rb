class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.2.0.tar.gz"
  sha256 "69d44c2a0ae0a2d6305d142ecfaf2c52f5f1dd25978af2595fdd1182298b9ee6"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/GoogleCloudPlatform/berglas").install buildpath.children

    cd "src/github.com/GoogleCloudPlatform/berglas" do
      system "go", "build", "-o", bin/"berglas"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "#{version}\n", shell_output("#{bin}/berglas --version 2>&1")
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 60)
    assert_match "could not find default credentials.", out
  end
end
