class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.0.tar.gz"
  sha256 "e61375feb183cc2c73764aaac92e164ea77f073206f7dbbfd4997c0efd38bfc0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "01ed715cd19b9ced52c17755df4666f6b16ec9252d9844b713e6381205f82c56"
    sha256 cellar: :any_skip_relocation, catalina: "91732e8e1bf94c18b3c06a43a675aed959c0d87b6ec3e1930e9b06e7a9b6e2e5"
    sha256 cellar: :any_skip_relocation, mojave:   "06d7521db8a6b3d9a03aae4d246ed48908491d3d4f3ba7d9f5051165e4cb2fd8"
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
