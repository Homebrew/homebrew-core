class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "a05ce362ca734c23f277e0c1485fed3cfcb66471fb2d1018104a98c4c57af397"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "531a59b22e2d49fce6206e0cb4147c89ed74a970e86cd3ed7687242be4ae28b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "322a95c889414e6293341c3a8b57e81526b4ddd5ba19a8770dc0425687b352d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d5debdac830ef5d82e1634b3c5a39430a363a14deddea86e4f889e56f9f4442"
    sha256 cellar: :any_skip_relocation, sonoma:         "038ebaa3c5b7870c6b3e61100fa5ab7c27013268980f12a148e5068eb1b21201"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d3546e921952e8e58b14a778c517fbbb3c8d8d027a2305cede26ee6b98ee79"
    sha256 cellar: :any_skip_relocation, monterey:       "8a8cfe9a1c24ad8bdef0a5e7c3d9882f928d9ac4fb23ef0c1358826f34fb9133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f9a949c85fe26eeab1fc2d2a7f6418639f1b90e8f65f617e9ef66fcee3f24cc"
  end

  depends_on "gradle" => :build
  # jdk21 support issue, https://github.com/micronaut-projects/micronaut-core/issues/10046
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
