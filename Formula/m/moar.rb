class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "eb1d63f9fc5ddcc493bf03622572499ecdcac9f9da81b5be2e9ab3740310de9b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68658f442dc461027569b307795f865c333d5dc12c42e6a3c84b455a077c7fcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68658f442dc461027569b307795f865c333d5dc12c42e6a3c84b455a077c7fcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68658f442dc461027569b307795f865c333d5dc12c42e6a3c84b455a077c7fcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c6fa1a4adb7c9edcc54ef752ebce8f69cf370ff96315701ddfaf1dfeb864595"
    sha256 cellar: :any_skip_relocation, ventura:        "3c6fa1a4adb7c9edcc54ef752ebce8f69cf370ff96315701ddfaf1dfeb864595"
    sha256 cellar: :any_skip_relocation, monterey:       "3c6fa1a4adb7c9edcc54ef752ebce8f69cf370ff96315701ddfaf1dfeb864595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8ba1b08fac28bbacc897ef26ffd8cbd79ca68e5dd06da6881528a72fbb5c6a4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
