class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.5.tar.gz"
  sha256 "b8054dba41c2549efac9deb226c3d734dfe6a3f6fb7da992715d4a97b0319b09"

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
