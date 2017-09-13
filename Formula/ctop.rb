class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.6.1.tar.gz"
  sha256 "68748870f1b0f67a210d7c963e196747882272180e9d651a1823cdaa8214f101"

  bottle do
    cellar :any_skip_relocation
    sha256 "a531dcdec44b373779e78d0b2e7030699923a06b20ba9e5c8d5d143d8ecba924" => :sierra
    sha256 "9c4ba36d5cd480f1b3ec0c9e1c843a7527a4db59f7033bdbd0b73bdb6359bd81" => :el_capitan
    sha256 "affade6fd575c5d7246ff3d323b700a30072daed4c05078e085834eff76d38ff" => :yosemite
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
    end
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
