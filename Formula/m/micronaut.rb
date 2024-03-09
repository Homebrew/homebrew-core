class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.3.5.tar.gz"
  sha256 "ee7f2046ee97d6f1ad9b88fc8f7b6e62bd415ed51bd364c9b269fe49dba5d73c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96189993fd443ade093fed09dbcb9d52ff9437286ade59921ee0ad1ad8d30dab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26f1f2fcdc7a91b881cfe500cf8f1630de2bf9e4bcb074d913383b88290dc38c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76a0ab9fe8b89b3c52451d54cb19f91c59bee144f6cf1f651448ac82cd2726e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c18d7328f247697034a784e1e52bf278d5dffd98b317f2ff699e16f38423629"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ff0fc4eb7185c7f192e7e693f962d3fb0c4b57b069a3a35e275b237bfee453"
    sha256 cellar: :any_skip_relocation, monterey:       "faa697edff5c4a448f7c3fe38d5fa5f81e56e2a33e5263f23468c38aec03b776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5310755670f591fcaa395d34fb1454c1caa4c3c0a39542fd8b0ef34dee0c59f"
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
