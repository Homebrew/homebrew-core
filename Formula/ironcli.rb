class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.1.6.tar.gz"
  sha256 "2b9e65c36e4f57ccb47449d55adc220d1c8d1c0ad7316b6afaf87c8d393caae6"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e72dc98b8ae2a512d8610d3949cf1fa383d30494af3fced6af2a22d2df0bd34" => :high_sierra
    sha256 "a243445511d08268bac87dc4ee042366e9cb7ea5ded3a011431150b06b4dc894" => :sierra
    sha256 "0382a73bd8168bcc4dfefb7710e7d377f62e49e15b83aa6ded26284a51be63b8" => :el_capitan
    sha256 "2525bf5e2917ccf70c17c920739aaac88353390ba7ad15068c3963d2c5838389" => :yosemite
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/iron-io/ironcli").install buildpath.children
    cd "src/github.com/iron-io/ironcli" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"iron"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"iron", "-help"
  end
end
