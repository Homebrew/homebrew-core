class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.69.3.tar.gz"
  sha256 "f89a1968ce9bc80bc7d446d245bd529a7409d42e65287e4bc0e0595d6b6436c6"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0c3dd6461c03017cbde424e4f1c4df68243c96e98bd0f71ad3ba340d132429d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c2b79b2e9bcfd3bac1535daed029e3c256614a20483e074d194e509f031cc25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d80b90fa2aca8f434a4b69043a8d8b30f0822ee908ba1aed73b6345308774f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f9301aff96717c4e64d51659865b696908bce055b50c36d6cfead0d1a1bdad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "983b9b46fadc378ba1ca8fc41f1137009d98bc78c495b74aed73f25aa61b3c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd03abcb0e1f618aea19804774c62093bc219b1ff26f685b060f834d380fdb9"
  end

  depends_on "mill" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mill", "--no-daemon", "flix.compile"
    system "mill", "--no-daemon", "flix.assembly"
    libexec.install "out/flix/assembly.dest/out.jar" => "flix.jar"
    bin.write_jar_script libexec/"flix.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end
