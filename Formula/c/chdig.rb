class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v25.3.1.tar.gz"
  sha256 "69fd0063279d4299d760a43a039ceb70064c0e8f24c9bec57c3924aaadcd4216"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^chdig/v?(\d+(?:\.\d+)+)$}i)
  end

  depends_on "rust" => [:build]

  def install
    system "make", "chdig", "build_completion", "deploy-binary"
    bin.install "target/chdig"
    bash_completion.install "target/chdig.bash-completion" => "chdig"
  end

  test do
    # Sometimes even if the compilation is OK, binary may not work, let's try.
    system bin/"chdig", "--help"
  end
end
