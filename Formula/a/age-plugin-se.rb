class AgePluginSe < Formula
  desc "Age plugin for Apple Secure Enclave"
  homepage "https://github.com/remko/age-plugin-se"
  url "https://github.com/remko/age-plugin-se/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "52d9b9583783988fbe5e94bbe72089a870d128a2eba197fc09a95c13926fb27a"
  license "MIT"
  head "https://github.com/remko/age-plugin-se.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55a0b7d025debf0f2de2c023e0590391e04deedea8c90068d041dd2926616d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1a850c11897c463a544f04473ce8ed580cba03618ff480e6acf5c7ed4d856bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdafa89da43cac1983dbc16e5f974766b729c8eda0fe79b67f85f55c546da28f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1e9f1d63e3860bb88c049baa8b4adaacb3263ce69b95b3bd78951752ad576fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "599dfc3ab78c9c6cf7bbacf9e3e0feab93a092d7689b66d485a6c8fc5971cdcc"
    sha256 cellar: :any_skip_relocation, ventura:       "b5be656138ce5035388f1430e884a0ef0424464c409c45d1ef1a7d8f439f83d3"
  end

  depends_on "scdoc" => :build
  depends_on xcode: ["14.0", :build]
  depends_on "age" => :test
  depends_on :macos
  depends_on macos: :ventura

  def install
    system "make", "PREFIX=#{prefix}", "RELEASE=1", "all"
    system "make", "PREFIX=#{prefix}", "RELEASE=1", "install"
  end

  test do
    (testpath/"secret.txt").write "My secret"
    system "age", "--encrypt",
           "-r", "age1se1qgg72x2qfk9wg3wh0qg9u0v7l5dkq4jx69fv80p6wdus3ftg6flwg5dz2dp",
           "-o", "secret.txt.age", "secret.txt"
    assert_path_exists testpath/"secret.txt.age"

    assert_match version.to_s, shell_output("#{bin}/age-plugin-se --version")
  end
end
