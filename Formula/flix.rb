class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "60f88048c517164deb8283435a21e942c3ea39f4bb7ea674a6f83fb0d211bc09"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b3d95e65de36e986e68df7ea0f58576503515a52d8f4820ff0577dafce81554"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31bb6276ef2caa9483ff96f55955eab80cd3497f7c2ed90e49ca4dd37d666aed"
    sha256 cellar: :any_skip_relocation, monterey:       "56b9ac75a783d21de2073edca1c978310fbb74b5580f20bc815a8a62925d4bcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f68f0c717b572b443be5846bdb0c967b6785b0db77d44e29176b924d40e20b5"
    sha256 cellar: :any_skip_relocation, catalina:       "35622aa9288ad1df8fcc97c22fee252342dd3cd7a27e3108f1b4fcf54f2e041e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99008c47a835112093e815a9a3acabe8a2b7b077b21c143f085e1922e470fe8b"
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
    assert_match "Tests Passed!", shell_output("#{bin/"flix"} test")
  end
end
