class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.11.tar.gz"
  sha256 "888d5b23033442f7d57a32c267ad0c7d0d052429a47ece567e6d256cf734f141"
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

  depends_on "graalvm" => :build
  depends_on "gradle" => :build
  depends_on "openjdk@21" => :build # If someone reads that, this is a test ... hopefully

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = if OS.mac?
      Formula["graalvm"].opt_libexec/"graalvm.jdk/Contents/Home"
    else
      Formula["graalvm"].opt_libexec
    end

    native_image_env = ENV.keys.grep(/^HOMEBREW_/).map { |key| "-E#{key}" }
    ENV.prepend "NATIVE_IMAGE_OPTIONS", native_image_env.join(" ")

    system "gradle", "micronaut-cli:nativeCompile", "--exclude-task", "test", "--no-daemon"

    bin.install buildpath/"starter-cli/build/native/nativeCompile/mn"

    system "gradle", "micronaut-cli:buildCompletion", "--exclude-task", "test", "--no-daemon"

    bash_completion.install buildpath/"starter-cli/build/bin/mn_completion" => "mn"
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
