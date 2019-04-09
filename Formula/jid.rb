class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/v0.7.5.tar.gz"
  sha256 "f741dee63f90b866f695a279634b0b28e4b432f3f59229cc3f0c8b4e32d4d18b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e46c621f6dc073f1f26480523ccd638cd8c82678fb17ace4637530b5f858dad6" => :mojave
    sha256 "e90ea96c64fcd6e9cca04ebf53b4ebc40982f3b9bbc273801c913a11ae85cb1a" => :high_sierra
    sha256 "8337cf1ac00b14b9e0d9854d6434a96d8d67913d8b83cf44b7e21c6b28c11279" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    src = buildpath/"src/github.com/simeji/jid"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"jid", "cmd/jid/jid.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end
