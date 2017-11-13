class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.6.1.tar.gz"
  sha256 "68748870f1b0f67a210d7c963e196747882272180e9d651a1823cdaa8214f101"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1053111c025a98b93f477ee37779529004eac0c89d7278087cec718dddd835d1" => :high_sierra
    sha256 "61ebd19e297de967aee46898ae9f440f19efdf3c7201a2c4350e570b8d43449a" => :sierra
    sha256 "cb3cbbbaed49ca7cdfcf803d17a7b9a67ff39f1f0808cd3566538deddb6f3b57" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/bcicen/ctop"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "make", "build"
      bin.install "ctop"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
