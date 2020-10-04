class Gitql < Formula
  desc "Git query language"
  homepage "https://github.com/filhodanuvem/gitql"
  url "https://github.com/filhodanuvem/gitql/archive/2.1.0.tar.gz"
  sha256 "bf82ef116220389029ae38bae7147008371e4fc94af747eba6f7dedcd5613010"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "git", "init"
    assert_match "author", shell_output("#{bin}/gitql 'SELECT * FROM commits'")
  end
end
