class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.3.6.tar.gz"
  sha256 "69119d486847e166fcb6f64a352f94e0add3b7e50d551c4e1a9d0bace5146be3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a682b82149660c2da8c1a4b1f99a2c38812a31fb3bd965d3e44b4211afc63eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f7584631d3816b054c2a109b14389360bfa965306368b8f3a08b13cb74d02d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d145f3ce0a865179acc0c4e12584055b19ae5390bda40ac28f1c992838ab03d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9ecab04dabf6f63f29a7bd6ff18cd7bd3216f7cda24298cd685228c7301a354"
    sha256 cellar: :any_skip_relocation, ventura:        "2b9f6cd83d70fe7515492854dadfc6d5f572115c5316bebc057c219a76c1f489"
    sha256 cellar: :any_skip_relocation, monterey:       "7dfd475930847bef70e7edb2285c48b289138d93213319db7d8d45d4f58f56d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b55d9e73f479e883d192c78ce898568505dcf567437d2a62e7ecfa0d3258172"
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
