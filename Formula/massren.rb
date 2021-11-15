class Massren < Formula
  desc "Easily rename multiple files using your text editor"
  homepage "https://github.com/laurent22/massren"
  url "https://github.com/laurent22/massren/archive/v1.5.4.tar.gz"
  sha256 "7a728d96a9e627c3609d147db64bba60ced33c407c75e9512147a5c83ba94f56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d717cb639b1f6fd247d21a7ac91c11b8ecf138fbc19187b9feb4651bce3faf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "899f09d133db12cac53c3d70ca93361e5f24167ccb89ae6e1cd97945ee6d257e"
    sha256 cellar: :any_skip_relocation, monterey:       "06b2e78ca54137a852409e5cb16e58156d5853ecc4557cd5148b8038b8e3cb95"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf6353befeba9f9244942cc577e808c9bc8b57bc9ee50410aeb1b8fb9848f80d"
    sha256 cellar: :any_skip_relocation, catalina:       "501c6c8684475cb9c83e57917be164e86aeba079fe7ac4523be108b10f2ef545"
    sha256 cellar: :any_skip_relocation, mojave:         "b342e2efbfe3400787138da378787ec54e9c3bfc1930dfae203f4baa378e4535"
    sha256 cellar: :any_skip_relocation, high_sierra:    "99afbeedc3d8ab1e3cf8ca525ac22f1b02efefbfd75b145b342f773cea639be6"
    sha256 cellar: :any_skip_relocation, sierra:         "14874a768ef7f34aa638cdbd62aa32d2b07fc5c0e6668c86f6f080f172f0fe45"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ea67caccb6dacdbed8979f3dc243e224ff1900928dedf1ea8800f5256f3456b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f63c928b2484ba780645184394e99b663b30d7035c45b9dc0a32212d24c41d0"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
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
