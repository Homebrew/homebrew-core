class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "a4d4f70b3f2e90c822725723e33b00c0630a8429313cf32ca1ddb7265737f719"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f1aadc3c2a56f57021e5a9a2372408987ed149d090687ec76c5792b2f2e7ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37f1b7e396f8bb9e6468e4b3c332b1bc61f9613762cb456731c7f30fb7c0b4c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0742eadd946b6e52853d97b18fb74c5f8daf511f38e5728bb0508a51c3d6cf64"
    sha256 cellar: :any_skip_relocation, sonoma:        "258223750404a58cd5e5220c00191dafdc74538311ffb96d1dd65d80dd414435"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f16ba1d114bc1172f9e8bf43f8731c57bb60a734196028b3687f088b9e412c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5765e88a1af01b2bec2833f4c7b06d976eea0abc5af81fcab0392357cbcba230"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("25")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
