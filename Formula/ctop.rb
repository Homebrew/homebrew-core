class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
    :tag      => "v0.7.3",
    :revision => "4741b276e4bbaa41a67d62443239d50b5a936623"

  bottle do
    cellar :any_skip_relocation
    sha256 "de0de48522c65a299d7d2a01b217eb0bfb591dd2606b3bccaa1ad3f8b8cbc485" => :catalina
    sha256 "07b42bcc8980f46bcca3808292b44cf5175fa6ba22ae5af2426b93e882d63f4e" => :mojave
    sha256 "d53ec344099ab1428ecbf13da5e970d0ea9567a4bfd355cc82c12047aba62de8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/bcicen/ctop"
    src.install buildpath.children
    src.cd do
      system "make", "build"
      bin.install "ctop"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
