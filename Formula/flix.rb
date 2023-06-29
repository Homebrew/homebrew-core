class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "e5756a5eb75ce7c1c3660581295041c1fb43b6f412349d89768ef544f346b084"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4968376b2b0295eff41e71a253aa22e8b40b6418321363d6f08d996b1e9ba73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ab34ce28ff1e7d817209fc8612e91bf624b2c0926a4d520cab76284e57153a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d953b49308c7ff26bbf6061ab464430f32f1e70b2b214ed1cacf4c7f464fdea"
    sha256 cellar: :any_skip_relocation, ventura:        "c0c3c6b20f25905780edabe1a9eb4ddee2b48d78e33e9b7cdacdb1b3bf37e794"
    sha256 cellar: :any_skip_relocation, monterey:       "75b4ef6406844bdf25bf69ced58de51f566f8a859709eeb63e5f1c94fb778d8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f9a378ee97ed27c307d362762e294d91e69ed9079232f0f7fdfdefc79b88eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1286ecd539f6f27f499b19bf6571ec2892569fc62473008f66d57c7b884ddb37"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    system Formula["gradle"].bin/"gradle", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    bin.write_jar_script prefix/"flix-#{version}.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin/"flix"} run")
    assert_match "Running 1 tests...", shell_output("#{bin/"flix"} test")
  end
end
