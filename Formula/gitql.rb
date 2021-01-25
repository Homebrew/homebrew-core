class Gitql < Formula
  desc "Git query language"
  homepage "https://github.com/filhodanuvem/gitql"
  url "https://github.com/filhodanuvem/gitql/archive/2.1.0.tar.gz"
  sha256 "bf82ef116220389029ae38bae7147008371e4fc94af747eba6f7dedcd5613010"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdb95fabef4aa65a6868b9f7967eae64eb2dfea636f66a1c078e54332840324c" => :big_sur
    sha256 "e66347dfe8941de456fd25f415291c54ee69e7b335f32098578b0da29c881cf6" => :arm64_big_sur
    sha256 "fbeb1c5d3f24eab8d0cb038fbba6f2900cab2dac9541826f301038f30656b6dd" => :catalina
    sha256 "362e70cce840cb4fd4df93de474047957e08bc5e522801d74756840caf3846f9" => :mojave
    sha256 "d382fa5dd8e22697cb6aea88970c532a2e8c6919d25ed5ed2a0c7ba5fea61eaf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "git", "init"
    assert_match "author", shell_output("#{bin}/gitql 'SELECT * FROM commits'")
  end
end
