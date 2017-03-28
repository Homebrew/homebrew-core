class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/smira/aptly/archive/v1.0.0.tar.gz"
  sha256 "d919ae4be762b689a03aee9eff9209091c40b7d37327fc718c981f4e1a77e8ea"
  head "https://github.com/smira/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "83d120b4f5f3b48b47a6100cc4abc284b4f43b5feb5344abdfc0230e9452cec8" => :sierra
    sha256 "76d08ae0643257baf4f6af5a60022251306f56bbafd24004f6ca415ebbaa2134" => :el_capitan
    sha256 "559e5c4c7fc0435597615fc6cd01a987ad66abe0ba7e49ff0284b1df46894374" => :yosemite
    sha256 "d53b704d71fd7f06425c48345b190125889ea5a8768d2b2a538c41d1b8c0e542" => :mavericks
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
