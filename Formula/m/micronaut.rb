class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.12.tar.gz"
  sha256 "4e2fdf95c406423cc9ba5ada86afcaa20642c051555c5f307fdbb0282c2e71b8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6d982263e5b8b2d151172c0a8f7c78faf1aae0fb45c42facc343d482ca1b995"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "304d456a56bb6f03e63330386f32d8e2657962c77d57ef223c15c49de87bc3b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0095b09e7ee4f3429816c9d970cfd72c619df3f3e12e2f7626855ca80c0d70a"
    sha256 cellar: :any_skip_relocation, sonoma:        "77a0f758b7e72c66cd3009f274e91d28bc0a0c4cb4bd275c445666c7e82ae9c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c439221530dd6af9be975f7d6c611e809eefc370a861ba6e6935f3b4a2f5fa98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "947b2efbb6d07d1e7acce62fb55fa9c12c30994630e27d2c49347679bc71680d"
  end

  # Issue ref: https://github.com/micronaut-projects/micronaut-starter/issues/2848
  depends_on "gradle@8" => :build
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
