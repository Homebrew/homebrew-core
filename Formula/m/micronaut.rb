class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "544ef22c9d047788a036663251a76a2ee7622d14f52e5a6e38e76268ada153a7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f670e23cf4fee1e5ffb8344f320af349daa126b255d2270701514c2b96c4634e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79671f9d2905b82506fba4f4a7094757bd10dba2e95fda8ed351e844e0e828f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1260db7c4382e1a47ce4828dc2fbccbdbe55333fefb9bccadd4d3dc96c9fa6dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f41fc1dab9140f015a0b2f5e4e378cdee5ba63a2b9e24a93c9d4b2d6fdc0cc2"
    sha256 cellar: :any_skip_relocation, ventura:       "3b8a523d8e4f9e620a38ae51259936276317863cf4b47055d491a02a8109d887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe17f5c8963103291a3c43e10d643eece1f980f6468625f721d6d93414bcf76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0b09c7163f0e213bd750a59c2ff00fd114fdd1fedf10dd1e1e3a465c00fbedd"
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
