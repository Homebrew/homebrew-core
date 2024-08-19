class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "2de62efd421f77923ef96c84fc70e9c963c970cdbf5fd5d1d42a56c3f3588e36"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5f8e3b5edf243a7f9dcaf1009e6cb3827ebca9de5789306b38969c817cadccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "476300f397ce2bbbc6e23e21a0b0d39b600c411e1cd19dc7c5773553b54c663c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31639314aacb61b69b1af0564cef0d35a94311b0b6b4308c3ec4592b31f36c3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "94915bc5212645d6056753d41d3cf09534556c6469d7d2fa0b078c285e2cdceb"
    sha256 cellar: :any_skip_relocation, ventura:        "df7992a09c4e07840120267a3aa931dcdf81ad903120bab36e02cfd6fd7c44d7"
    sha256 cellar: :any_skip_relocation, monterey:       "23e497fc6ccfe9daff056c9ad2b47e6ba4581f70c97258e3bb1524b0c2ebd1ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772ae8fd559082c673ec39ae801c62c6edc7e65683606d990e4fa56aca0047d0"
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
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
