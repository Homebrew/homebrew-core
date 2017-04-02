class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.1.4.tar.gz"
  sha256 "5ca1dee3732ae679353872b6be5fe9aa7e6119892fb477241c95a2546e140067"

  bottle do
    cellar :any_skip_relocation
    sha256 "a243445511d08268bac87dc4ee042366e9cb7ea5ded3a011431150b06b4dc894" => :sierra
    sha256 "0382a73bd8168bcc4dfefb7710e7d377f62e49e15b83aa6ded26284a51be63b8" => :el_capitan
    sha256 "2525bf5e2917ccf70c17c920739aaac88353390ba7ad15068c3963d2c5838389" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/iron-io/ironcli"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"iron"
    end
  end

  test do
    system bin/"iron", "-help"
  end
end
