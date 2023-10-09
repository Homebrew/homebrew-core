class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/filiptibell/lune/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "9c29f240d614c8af8d7d0a7903a02d084f5df1280818d9f623a47a2f7a86504f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b333cab0d16c2ba032cea3d551871837d063ec8d202d8a73b2f28cc44de0b583"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92b579bcb111916f95d4be8ce0c2fa13d74ed9f4fac04b54e36733d0807648ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ce05550e8ccc76de005b7374c2a8f2c0c922a53b71584e1eaf29e0f3b6ed206"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba05ec05f8fe1cadb637827b5e6389d0f98101aceb62c21ab77f7dfc563d55dd"
    sha256 cellar: :any_skip_relocation, ventura:        "9791c7a50c9218d11999e7a05964508c15e3225b317099be8b5795f3e3cdfc5c"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d8da093c59ebdb43f123d3e79ce7b6b4832b27a7f86040dc6cccf1f57c5686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8f9ff5d20b6ae1a25309f768319b6e099743abdd0d6efa28a172c611276ea7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune test.lua").chomp
  end
end
