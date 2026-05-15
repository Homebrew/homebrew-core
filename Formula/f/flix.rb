class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "22fdd9685f5a3b6c9ee03c6c52704f0876bb70be5d53750793133bf160898ab3"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60cec842ad0b6759a873c84fe43b168568553ab522c7c61d61e187f6bcb96850"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "383dd12cada22f1760fcc438c462ac45ac1e7aab4ba8856ba8c279b62f285794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e3890632428bcbb2280369b9dbd3e6c849ec768c438de8672aebad025336a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "b473714b3d4ada800dc87baf1d472e15aa7aa198265e9f2335ebc04c0f55bbad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7229efc72621211e2914ff2d462e39f1f8757cf88b926b8afa5e75a4fb036192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05a9aff399dc2652e4c43ab40695b5810e7fc52e0b001fbe6d616bebc088c9ba"
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
