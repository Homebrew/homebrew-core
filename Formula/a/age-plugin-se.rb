class AgePluginSe < Formula
  desc "Age plugin for Apple Secure Enclave"
  homepage "https://github.com/remko/age-plugin-se"
  url "https://github.com/remko/age-plugin-se/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a22ba4de99a6463b044894e0d7d26a2c9859be6577e2085b4082481e1ae6e6bc"
  license "MIT"
  head "https://github.com/remko/age-plugin-se.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "c0f6ab0e7b132e6ab579e0267efc666edbb8fe6aff0621d64c4bc5db2dd386cc"
    sha256 cellar: :any,                 arm64_linux:  "9afcc177c0f73d09c3adc17a424be38da65a843311293b241e8915b6e4689dc6"
    sha256 cellar: :any,                 x86_64_linux: "4d94ac4f95bf5f104863734bf3149d43ac3bacf116f851f083762e8a6cca143f"
  end

  depends_on "scdoc" => :build
  depends_on "age" => :test

  uses_from_macos "swift" => :build

  on_macos do
    depends_on macos: :tahoe # cannot build on Sequoia with Swift 6.2
  end

  deny_network_access! [:postinstall, :test]

  def install
    args = ["PREFIX=#{prefix}", "RELEASE=1", "SWIFT_BUILD_FLAGS=#{std_swift_args.join(" ")}"]
    system "make", *args, "all"
    system "make", *args, "install"
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
