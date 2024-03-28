class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.3.7.tar.gz"
  sha256 "189a979a1f64838c935cc673abb01850dbd084dda6c5feacb2494acd4b7de983"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e795a1d45daf0d7b7f87848bb2747d213e72734641476ae6d97354767c5750c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "085f29a72e55ef3486617c6e939b5e961657c359dd21690b10d3885a0c7db7b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c2ab11fc6e991f11599cad5eb5490f829f2594fd3bd57b064fd8bce9e29baf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ecbb465bc1ac799d42f8a3141abe4631b17cefbf204571fb2a0308607312217"
    sha256 cellar: :any_skip_relocation, ventura:        "4c7037ead4ed709db1ff61c87d18dfa06b961d32ff6dc125bb5a41b3696398fe"
    sha256 cellar: :any_skip_relocation, monterey:       "a53117ae09ab40c966147698f8712dcca686a8fb58da238017d046f31fd7a86a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "928718bb001880ce90a97c168fb09b2c60790b86aead46ee3720ed3d99f34e7e"
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
