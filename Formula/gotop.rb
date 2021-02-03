class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.1.tar.gz"
  sha256 "314dcfc4b0faa0bb735e5fa84b2406492bf94f7948af43e2b9d2982d69d542ed"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "01ed715cd19b9ced52c17755df4666f6b16ec9252d9844b713e6381205f82c56" => :big_sur
    sha256 "91732e8e1bf94c18b3c06a43a675aed959c0d87b6ec3e1930e9b06e7a9b6e2e5" => :catalina
    sha256 "06d7521db8a6b3d9a03aae4d246ed48908491d3d4f3ba7d9f5051165e4cb2fd8" => :mojave
  end

  depends_on "go" => :build

  def install
    time = `date +%Y%m%dT%H%M%S`.chomp
    system "go", "build", *std_go_args, "-ldflags",
           "-X main.Version=#{version} -X main.BuildDate=#{time}", "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    assert_predicate testpath/"Library/Application Support/gotop/gotop.conf", :exist?
  end
end
