class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "c01da8b74be0daba79781cfc125ffcd3df3a0d090157fe0081c71da2f6057905"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6640d4124619c0e3d007cb0284f2fb33d393c279baee741432d586c28e48f612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c9528218834611e0d11368cd892d576887fa0c614cda521203b9c665b000785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cbeb6a465786ff60f02816f708b1184612fbb27a3142cdf9731cc70f6b5ec59"
    sha256 cellar: :any_skip_relocation, ventura:        "633076498c9549f079573bf14bd52590fa001929e36136047f99369e2cf86f84"
    sha256 cellar: :any_skip_relocation, monterey:       "e4e51038926d8e3e375f02c0e1511c7eb8274a40dfb4509f8d0d36e5a4ee1ff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "411fd9ea3515958e15d197598cfe7e39cc9087cb86c2fd13db6e5af8dbb78864"
    sha256 cellar: :any_skip_relocation, catalina:       "9e03831868de123c9a3b9b42c6d954cedfe1241bf8c4dc5c234adca1a9ffa871"
  end

  depends_on "rust" => :build
  depends_on "python@3.12" => :test

  on_linux do
    depends_on "libunwind"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"py-spy", "completions")
  end

  test do
    python = Formula["python@3.12"].opt_bin/"python3.12"
    output = shell_output("#{bin}/py-spy record #{python} 2>&1", 1)
    assert_match "Try running again with elevated permissions by going", output
  end
end
