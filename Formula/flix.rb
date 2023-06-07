class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "fdd894b4fb19c7e45423f318fa5a90ec5c06ac90b27da1397f6d643b3fcc5468"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79ae6274f3318d67b3388748af919799cec178220a91603d97ddeb164b461101"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e840fa5ef630dd78ffc35ffb43e0768e1abf204880b541c9ad85f3a030b422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "016156a6fae3126811e516a59f373f3dec0f8eccb331ef7f029057f75b218237"
    sha256 cellar: :any_skip_relocation, ventura:        "0ccdadaa17eb36051c88e12c3153beca08605bc4ae16134f50f9a75519bfae0d"
    sha256 cellar: :any_skip_relocation, monterey:       "d9afea74049b0e593f6dfaed21797ae2a7dca04ed614cb0329edb5154375115d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b45a09500b458637593ce1fd91f822b37c61002397bc350c0ba9689553897e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67119992a45d7df743c37d7069e7fa2cde9c3721d5e49cce867118fe733f8073"
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
