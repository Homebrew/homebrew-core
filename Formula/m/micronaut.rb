class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "f240e92b52694d18eff729dd737cfb52098a1a1507e1d590ffedb1c7d812012a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc1a3e4c3bd7f085b1e73568bb88301e935bb97ed1d640fcb046b10c1b4a4a8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d60f206273409aee1717bcf837e2c2942c4e75ee529ec0b5f033e4705daf01ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7ecb86ab9886551eac12277c4921426546fe2f6d28c318cef9d5977a1dfd451"
    sha256 cellar: :any_skip_relocation, sonoma:         "24ad3f15e7081eb21af01dad33d956de8494cc9d24808f6501e2016ca783da9d"
    sha256 cellar: :any_skip_relocation, ventura:        "4903ac25dce85f80e3866e4942c629b68ee2272a6d90d6906c1f23cd838b5688"
    sha256 cellar: :any_skip_relocation, monterey:       "77df1100670bec14c5a87b394d1d7e00b3823c93775286b38b4969af1ede76e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5b71630ff6353f5993abc3bbdfc4159e1156b5d7cafc47f9dc5e72bf76473ba"
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
