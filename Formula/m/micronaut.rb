class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "42de8717790de998ff088b01a871985e50d19c5b19531bed6ce142c5d3a0bf80"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be306b59b0777baf2278993090f757f08d6f85e2be423d9000671488510d64c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "430640e4cfae532e82cb147c9e92d7339408869735f016173773bccb0a1f36fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b4247514f1c258b90d9031e7342fd0884a3360272cc543ee8b93cb4761fb1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ad5ba07f61afc9897c102ea4f76cdb4dfd9456630254ca7640aee83f93b1922"
    sha256 cellar: :any_skip_relocation, ventura:        "56f24ca7d4f5a08c5587034278700ff82f411721a543db5059c99c4308d87bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "8a3200bdcf76d82697624460325798ea3f28dce2eca2aa9c5d65a06aa3a911dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e29ed13ca70b917ee08f6d78246d56cde91d631844ab18256a62e799aad028a"
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
