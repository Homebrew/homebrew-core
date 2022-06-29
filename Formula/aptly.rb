class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.5.0.tar.gz"
  sha256 "07e18ce606feb8c86a1f79f7f5dd724079ac27196faa61a2cefa5b599bbb5bb1"
  license "MIT"
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "692eb1a5b0cfdc72267072c38ec91ac0e09c3afda313318819f3e06f6de16840"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8e56fb7954c129c0879918c382b762a998d25eee9fab0b7c7fcb2f20d5a2807"
    sha256 cellar: :any_skip_relocation, monterey:       "b0abc4e127dd981e976f725e56a06111fe7b120fa300d53cadd3230ace8f2ea4"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfa5263df4cf003ef7a928b5ac73da07337ba666929dceecd7c279b784d4bad4"
    sha256 cellar: :any_skip_relocation, catalina:       "413b36d3c1512a089dff010cb3e39a71ebad07570fe7c87c8413709fb093e677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c2015a999ea878b0b5714f1a261100974f3c8b4834cfe1406447f50821e3ec"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/aptly-dev/aptly").install buildpath.children
    cd "src/github.com/aptly-dev/aptly" do
      system "make", "VERSION=#{version}", "install"
      prefix.install_metafiles
      bash_completion.install "completion.d/aptly"
      zsh_completion.install "completion.d/_aptly"
    end
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
