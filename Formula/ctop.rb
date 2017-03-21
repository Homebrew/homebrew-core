class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.5.tar.gz"
  sha256 "b8054dba41c2549efac9deb226c3d734dfe6a3f6fb7da992715d4a97b0319b09"

  bottle do
    cellar :any_skip_relocation
    sha256 "c37eaaaeb6eb5a9a1156be25439b9c7054d6b5437f119418c509a40ee732af4c" => :sierra
    sha256 "13c419facebf37cdd92b182eefa5f71789e541e9f2d0513562f2e42f4131528d" => :el_capitan
    sha256 "ae9d6a1f77e9e86020996dc7bfbbcaa2a977615453a5f4da33899ad6053cacb0" => :yosemite
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
