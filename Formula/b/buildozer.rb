class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v6.3.3.tar.gz"
  sha256 "42968f9134ba2c75c03bb271bd7bb062afb7da449f9b913c96e5be4ce890030a"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fccf31e12287e34974a71cebea42fdc7e3666f9ef83ce81595314baa72def47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44dafbb1c84789d797d058866923ff1a69bbece2dc9b8b53b09892a3cd4c5660"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44dafbb1c84789d797d058866923ff1a69bbece2dc9b8b53b09892a3cd4c5660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44dafbb1c84789d797d058866923ff1a69bbece2dc9b8b53b09892a3cd4c5660"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c0678842a82748cdad1afec72c491ca74f0ab900261b8427d4f63784003ec21"
    sha256 cellar: :any_skip_relocation, ventura:        "2db7613080f4212fb9152e23e47417543df9b3a571f4badb2c3a22d18c6345ad"
    sha256 cellar: :any_skip_relocation, monterey:       "2db7613080f4212fb9152e23e47417543df9b3a571f4badb2c3a22d18c6345ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "2db7613080f4212fb9152e23e47417543df9b3a571f4badb2c3a22d18c6345ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1416f91727b61af753560528a90866bd6c5caf62e6b858e7ac3eec6ca5efa7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system "#{bin}/buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
