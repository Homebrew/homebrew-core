class Massren < Formula
  desc "Easily rename multiple files using your text editor"
  homepage "https://github.com/laurent22/massren"
  url "https://github.com/laurent22/massren/archive/v1.5.4.tar.gz"
  sha256 "7a728d96a9e627c3609d147db64bba60ced33c407c75e9512147a5c83ba94f56"

  bottle do
    cellar :any_skip_relocation
    sha256 "b342e2efbfe3400787138da378787ec54e9c3bfc1930dfae203f4baa378e4535" => :mojave
    sha256 "99afbeedc3d8ab1e3cf8ca525ac22f1b02efefbfd75b145b342f773cea639be6" => :high_sierra
    sha256 "14874a768ef7f34aa638cdbd62aa32d2b07fc5c0e6668c86f6f080f172f0fe45" => :sierra
    sha256 "ea67caccb6dacdbed8979f3dc243e224ff1900928dedf1ea8800f5256f3456b2" => :el_capitan
  end

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
