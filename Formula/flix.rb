class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "08065fabb782dc417ce1b76591810ed5f20e3748d24d1e7453992b72f4d264dd"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfc7a9952aa1461251c7109f6a0d0fa9d0307260f1efafbba1877e591464b579"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736762e6f9d3802f0cd90a9848282c56bb03f6fbf6d5da89b5f2be5414c71b3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef20e4f6aa582044bb5d36345ac8d2e7a868a1ddcfa3e86c1e2227ad6d326e49"
    sha256 cellar: :any_skip_relocation, ventura:        "a660a92fdcaae1a494c0b0348a067e2f4e3fb8e55587dde60ec858c1ea0a5856"
    sha256 cellar: :any_skip_relocation, monterey:       "06ffccb4deee3d8be0765a4455c5e9531eff65266c5691457c1ba2873eaf919e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a1a845ce32117c8f9e33220e9aa54e71be46bbb60f018ab224a9a350d622c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8192b78068864f6d8205ad5f6ef82877da87714932f0cfa7b315d24153b3bbd0"
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
