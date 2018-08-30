class Monax < Formula
  desc "Blockchain application platform CLI"
  homepage "https://github.com/monax/monax"
  url "https://github.com/monax/monax/archive/v0.18.0.tar.gz"
  sha256 "8ad3166e3ca76738c6542bd8b85dcef1643b68a3755abe3e0a7f3c9cdd027afb"
  revision 1
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e0a723c4524d466b0918ac9978d339cc5129259efa7670e833673e85412a8aef" => :mojave
    sha256 "3c20e0042a3559ff46d08dc01cba818d643b0f21001e7a9cbba7a4d0c10aca29" => :high_sierra
    sha256 "d9db4da71b98d06156aabf6ce2033aa694a367a3e153a75ae9b7d677b4e85271" => :sierra
    sha256 "3b90f4e7d08b91f47da2c80b4e801fc15d153d7ff27c492240559f9d62a6a597" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/monax").mkpath
    ln_sf buildpath, buildpath/"src/github.com/monax/monax"
    system "go", "install", "github.com/monax/monax/cmd/monax"
  end

  test do
    system "#{bin}/monax", "version"
  end
end
