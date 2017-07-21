class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.1.1.tar.gz"
  sha256 "d6548a96249c398546ba70ae83eda1d9172174966ae9586b806db926928843be"

  bottle do
    cellar :any_skip_relocation
    sha256 "e75485aca676727e73df65f65924ac7e815ef9e3541118593b510e40e13e6fc0" => :sierra
    sha256 "7477ecde0341bef4435185a6c15db4e8676d4441086a526e5ff58d6cbe052798" => :el_capitan
    sha256 "1d2399080a05deef0dde6bc0354ab5bc46d2fddc693e4c2c6c309695c2408562" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "glide", "install"
      system "go", "build", "-o", bin/"akamai"
    end
  end

  test do
    assert_match "purge\tPurge", shell_output("yes | #{bin}/akamai get purge")
  end
end
