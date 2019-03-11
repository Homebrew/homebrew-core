class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.12.0.tar.gz"
  sha256 "d1b95e55fc4e995de7909942dd031cf218fcb6e3ffbad2cdd2c527b34a7dd2bd"

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
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"ghr"
      prefix.install_metafiles
    end
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_include "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
