class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
    :tag      => "v0.7.2",
    :revision => "70bd2ae3a3476969cae3c7f921d38b130ceec648"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2e2f235137e94a3480bf54a0ef951665756736e38db7e0d61bee478e03d550ce" => :mojave
    sha256 "6d86410f2860a8d05d15b4cb0ae22a940de3968d75209493b3988d0c456b0b34" => :high_sierra
    sha256 "143755c7fee144254c6d3fa401a607aae977820acf199f954ff8cdfabf336235" => :sierra
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
