class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.7.5.tar.gz"
  sha256 "767b6905634de8a0007bf3433bd32ad8a4c6126100f28048d01c5704384d8405"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c31f192233f3ce8987767993cbdf5fb3d18f074cf8cf4a99248be8638407c1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edab722715cc6379dfb65e935654172a415899d7199bec8d028f666f6d957583"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68e3fbb645848200d50b589b701b245a2d3f05f08eaf8efbef79b6b1a7971b10"
    sha256 cellar: :any_skip_relocation, sonoma:        "3976d76a8b87bd15e961f1a2a5767d0ec5290ad7041387162373cbc56006e3f2"
    sha256 cellar: :any_skip_relocation, ventura:       "ba08ed57dc9b17745b6c56a7259d7510be6a8aa03981ff47d6c1e8af38e49384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96f96787205811e8550f0d7c9b010547804b6c3160a8fd6208b53a185b3997d6"
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
