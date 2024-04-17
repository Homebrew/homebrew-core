class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.3.8.tar.gz"
  sha256 "ae12ceaea1575bb8a0f2bdb7941bbc99c77dc5849c5d95e982a01618f4d87c79"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ebc0926cd07d758ea7ac14e32725109f7c47fc26b4a871a8cd07ace711aa19c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdc5bbfc30c8dd06b992578fb5d6592f90f22209277fae89f13e57574e337ca8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb69a544c69ba262e077cbebe5a3ddf79fefe2c48d0159d106ae1b1e1031b79e"
    sha256 cellar: :any_skip_relocation, sonoma:         "50ab5cf2d0f392c592821bc8d47fd447debb2ba9d8f6958b74bd4f2aa719e56d"
    sha256 cellar: :any_skip_relocation, ventura:        "0ebd77ab48832570b51c114bda9035aefbc37fa4ac1e86abb05fde4312244967"
    sha256 cellar: :any_skip_relocation, monterey:       "8dcdab1bb195063b7c578a6796f9e322d40e98dfc1d547cbd421d3d9ffef50c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20eaaf2edeb5caac910a7b96aded64de4f2357129e0fc3df11da4edaf912a828"
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
