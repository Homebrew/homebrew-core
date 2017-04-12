class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/smira/aptly/archive/v1.0.1.tar.gz"
  sha256 "e7431e56f0850751c8d6e06e8a0db7dc0d113a60fecfb22c230846f5a7365881"
  head "https://github.com/smira/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d769447635d35442dd39a40e59096e999ae427e4ee3ec42d0f9331c5db74c75" => :sierra
    sha256 "8afbbb462f8a0c7d6bda1ed77984d79dda2ffce83d2f233c9e5e5f043f76c73d" => :el_capitan
    sha256 "1b10cdd4d43b5da6d8cc1b54f0122895428b7834b4627c3221bde158e42d9267" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/smira/aptly").install buildpath.children
    cd "src/github.com/smira/aptly" do
      system "make", "VERSION=#{version}", "install"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
