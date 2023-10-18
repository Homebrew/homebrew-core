class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "77161350c30e543d86779ad8cfdfcede221fca2f61d46d24a0a66073f94a319a"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02fd0624254e2467f5c3f88a390ab595d8548b6bdf3ceafbc513c41ecace79dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d1ced5d3a9d4279c2b98691c6a393f35a0488f7229681b78e8e9c4aba2b83fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb9a02b24b2604d0d5791c586e93f2fc2e11396bfbb54b5b986c05bf5333203a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dd3a1782761ca19750bcddcf121751e70495aecfed443d12aa5d54ead3b3240"
    sha256 cellar: :any_skip_relocation, sonoma:         "374bb0e5288e13fb103bcff9cdd928129c7feb8831081edf96b0372fddf11a12"
    sha256 cellar: :any_skip_relocation, ventura:        "2d5af7fd44678f04a14eddc8b0a3c60808922a3d3b246943afd5c0828c35b097"
    sha256 cellar: :any_skip_relocation, monterey:       "207de2c6477a3d934d4ff92410eedcc884e129644d905bcd60e025adcfb5eead"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c09a50fe4010015c9cef1e53b2a2396680c2cde62740b123d6839a6597c7dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50a62677dba8d980954da45cd3822141a2d042ef6b6ee6ae5e7f921a8a6ec1a3"
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
