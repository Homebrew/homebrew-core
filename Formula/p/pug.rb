class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "e8c54f5831e89b45e1cc9fb31306a2ea515f71bf48f0495d5f521f48855e47ab"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9823a6bc2afe1b407640791ebfa1c453148822c760b1443600fc246b5ce7aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c9823a6bc2afe1b407640791ebfa1c453148822c760b1443600fc246b5ce7aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c9823a6bc2afe1b407640791ebfa1c453148822c760b1443600fc246b5ce7aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "c50cbbc4c28f89cf45135d70105af993667cc3ce9584f57cf16a4ce54d773528"
    sha256 cellar: :any_skip_relocation, ventura:       "c50cbbc4c28f89cf45135d70105af993667cc3ce9584f57cf16a4ce54d773528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a5abc018784c4c595b4782bb64d494f7444dc404654eaf0196827171419ac3e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/leg100/pug/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}/pug --debug")
    # check on TUI elements
    assert_match "Modules", r.readline
    # check on debug logs
    assert_match "loaded 0 modules", (testpath/"messages.log").read

    assert_match version.to_s, shell_output("#{bin}/pug --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
