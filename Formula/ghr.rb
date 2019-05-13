class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.12.1.tar.gz"
  sha256 "d124f7ad2d4bd5be2d6c51ad4d780d69fffc19e41440f7f14bcf2a24d415e006"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e9e77299a9e7d8b1e885c68d31ede1b021e297377ee9138f0677a41f4dae638" => :mojave
    sha256 "42d87636d801c4525409853eb056fb045e4c8407092cb8c9e3af05d05bbf8c19" => :high_sierra
    sha256 "5dfe9178b200cfbfde6641d72b24ec1f522b71179781877fbb24c31791c5480f" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/tcnksm/ghr"
    dir.install Dir["*"]
    cd dir do
      # Avoid running `go get`
      inreplace "Makefile", "go get ${u} -d", ""

      system "make", "build"
      bin.install "bin/ghr" => "ghr"
      prefix.install_metafiles
    end
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_include "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
