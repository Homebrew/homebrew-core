class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  version "0.4.1"
  url "https://github.com/bcicen/ctop/archive/v0.4.1-deps.tar.gz"
  sha256 "39c4247a7c6715bc45db078769419ff9bdab1219378ac39cb97febbc0130dbf5"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/bcicen/ctop"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"ctop"
    end
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
