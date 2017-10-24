class Massren < Formula
  desc "Easily rename multiple files using your text editor"
  homepage "https://github.com/laurent22/massren"
  url "https://github.com/laurent22/massren/archive/v1.5.4.tar.gz"
  sha256 "7a728d96a9e627c3609d147db64bba60ced33c407c75e9512147a5c83ba94f56"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/laurent22/massren").install buildpath.children
    cd "src/github.com/laurent22/massren" do
      system "go", "build", "-o", bin/"massren"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"massren", "--config", "editor", "nano"
    assert_match 'editor = "nano"', shell_output("#{bin}/massren --config")
  end
end
