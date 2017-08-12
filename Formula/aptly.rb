class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/smira/aptly/archive/v1.1.1.tar.gz"
  sha256 "92aa5caa12d756cb7469fa5772a03d7631b73d655b7329408a4d597ee8fb0ba4"
  head "https://github.com/smira/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b2b48ae572475397cf32490422b5ac16b806063bf0280adeadf7e9fd135e0f0" => :sierra
    sha256 "9586b3a09cb4267f928b045cb13f2e210a30b971b5e9b0e04575128e616789b8" => :el_capitan
    sha256 "764451d229c92b48a3df79e074b761df632da13e661955ab1a767669ca631662" => :yosemite
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
