class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/v0.13.3.tar.gz"
  sha256 "817dad2f25303d835789c889bf2fac5e141ad2442b9f75da7b164650f0de3fee"
  head "https://github.com/Masterminds/glide.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1f33381b136034b0940785e703098ea99f8550895abe890b9edb850303364d8" => :mojave
    sha256 "181f8aa3ef425517c444d303c9ad44c8062f8305ea40db9b8419f2b2b53ad045" => :high_sierra
    sha256 "a925a8c1930e77ce29406e3cc5783d380dda884aef053ad1b0d85ca13da3d740" => :sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    glidepath = buildpath/"src/github.com/Masterminds/glide"
    glidepath.install buildpath.children

    cd glidepath do
      system "go", "build", "-o", "glide", "-ldflags", "-X main.version=#{version}"
      bin.install "glide"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glide --version")
    system bin/"glide", "create", "--non-interactive", "--skip-import"
    assert_predicate testpath/"glide.yaml", :exist?
  end
end
