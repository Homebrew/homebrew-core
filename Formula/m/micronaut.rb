class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.11.tar.gz"
  sha256 "c5f4187cb9c2407127a3fda64680ff50d073d5f39cacb9d7a6e04689423b7328"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3b792834f2447ad6b28be5309a44d10588e838dcc9a55bdca5fb4621183eca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7af2f10db338e870014153c6ce44abbc24d4a75e815a24b5acfb6beca0d28901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3fa5709d5619527b6c21eb531c54db8f139a40b44446654b9c5ebcea3664801"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ca1dd13a4866dec3e7a829546eaa809e2031bcf2469521962100fc022082d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c19a6bf437ef4e0707a9cfa61bf68f4c52edea916f5febcb0848bbd80c7d5827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b08eece94522458a6a4e6be11c4c312b7c4d67a799e29a376906e61051f9f720"
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
