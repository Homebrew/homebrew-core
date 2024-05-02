class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "59b612c57fb0c620e5ef131d2d23ac8fa498b25542776a0840c2224b13b19f08"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3122e848b186cb60eb6d39d30560c5762ac6da672235ce330c5445aa22b12d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "473057d4cc3a8450e28df842ee7f532c8461b6fccda42373382b39009bb7e42f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cd561f146f80c7fb821af5c51ac4a06159c11563541b66bd5c53962d5f13abb"
    sha256 cellar: :any_skip_relocation, sonoma:         "95bb3858783e731553246fb1897723e8a202a1068fa802b96b7960c37a2a4e07"
    sha256 cellar: :any_skip_relocation, ventura:        "6baa7accdfb651f8e4a1f6ba2ce37b57b1506915162f0a1bb94e2fe05690e2fb"
    sha256 cellar: :any_skip_relocation, monterey:       "b0611c4794c3f4d8594e6fe9dceef30b0fed4bedae5d23a6c302e1e7f5cd1c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f421c6f6ab55526b87c83fb3432e1e9c1143ab673b8cbd369c9843bd9e62a5d"
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
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end
