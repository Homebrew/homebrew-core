class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.1.5.tar.gz"
  sha256 "759c3c3bc59c2623fc8a5f91907f55d870f77aef1839f2ecc703db5c469b852a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:  "6ce7c1b2b58e3225295f90b5d83f4d3a7df4530b769ea44c716aaeec35b498d2"
    sha256 cellar: :any_skip_relocation, catalina: "e8c599f32b5f7a489cee4723d378661c8aa12fa7ed3f1bef5e15c27f39a8cf87"
    sha256 cellar: :any_skip_relocation, mojave:   "1d96850b0c979f5f351877977b7d06e5b26a78701a8993ad6366b229c15cae97"
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-tags", "noautoupgrade nofirstrun", "-o", bin/"akamai"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Purge", shell_output("#{bin}/akamai install --force purge")
  end
end
