class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.9.3.tar.gz"
  sha256 "b4ee02995200e09e9cc1893b87c1aba4a4e0c6144caccb0b3c46bd5cd2fbb9e6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d65e4f16a1024fedc674df0141f46f30d9c7d03240f327bdf23a1a6ad8358f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b560120018fa275cef83da12f10ded8afaafea0fa8adb01746d17e216af0073e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c1736e65b39b05548810e1223894da575a9653f41839d4f0bc60047f82e1d16"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ada075670cf0cc45de5530c14100a289bad45b9cf3330741a74af58def97389"
    sha256 cellar: :any_skip_relocation, ventura:       "df2e2d11183886c96b8fc9c8348fb3d220c289ccde6d387f4f33544caa00c4df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "592f8e87747791193dcf26d6a045a86b5054e00eaf11ddfa37e634f4aa3a3c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891bd5e6187d49985683404e41dd85edbaf3db639d9a4ff0b82de3f93829ca60"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("21")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
