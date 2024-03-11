class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "993f6d6d9537dfd61b9ef5545666574abb2b1b4fc362d4bd8d7b5a203f5becda"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e7ab0cc56342ba3e4d194e15781ef96e47b832b03f47ed9ddd591a264c468b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2f35722422a532025230fcc3c043cf9c34a988eeb77618d7a3f35b95bf2c073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3070385eb6784e5340856f8edbb58abfc10ce1bcea15acd3b2651608d2d52daa"
    sha256 cellar: :any_skip_relocation, sonoma:         "40a2b78684bb4d25d50e0a3f02e851e208ad3e040fdc1665939552f233e97407"
    sha256 cellar: :any_skip_relocation, ventura:        "3ec2598f21226acbeb6621d2968fad0ed99cbfb66bee905c3f2aa4e3b1dac4c0"
    sha256 cellar: :any_skip_relocation, monterey:       "7127d33ffd525f9c4fe33a14409d95dfb9ba65031c53699fac19928f6ac4f161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4737c6d25191df601e4074e7adfefac69dd9cdabdd381c47473f6e6961f6258e"
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
