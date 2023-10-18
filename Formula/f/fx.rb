class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/30.2.0.tar.gz"
  sha256 "36f2c3fb6e349f3bc2b416c1ccdc2a17a93912fb6d1d7cf72941cabd467b9922"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1624df276e66cac0371cc67bf3a201934abf092d6d720f038eda7d2ad57bb8dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1624df276e66cac0371cc67bf3a201934abf092d6d720f038eda7d2ad57bb8dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1624df276e66cac0371cc67bf3a201934abf092d6d720f038eda7d2ad57bb8dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "081b5cf7c25d3e1dd72bfe54f3aacf14eed39358d42b238ad7c35b7fda413861"
    sha256 cellar: :any_skip_relocation, ventura:        "081b5cf7c25d3e1dd72bfe54f3aacf14eed39358d42b238ad7c35b7fda413861"
    sha256 cellar: :any_skip_relocation, monterey:       "081b5cf7c25d3e1dd72bfe54f3aacf14eed39358d42b238ad7c35b7fda413861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef6797b1f0adf558d9630dd4fd205ad0a2d854d28007f111a4d105ec1684820b"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end
