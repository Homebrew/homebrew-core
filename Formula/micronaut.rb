class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.2.3.tar.gz"
  sha256 "d67f066281509978a26fcf3d33b01e3889b7750e224fca0c5107b37ac54773c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4963e5d5dc24129156e5bd43c46bb4f1935823f21c2fd296894b03919b964d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "3cc93ace8f496362f429885d3ea07c49d155d60b6059a51be73153fc0461e1de"
    sha256 cellar: :any_skip_relocation, catalina:      "e0e070cd304e01597d635f46dcc970d6c351526f54b3bbf73c41265a42a6400b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51171280ae5fe232db5c89b8150eb90594865548f30517c887f326473144a3d1"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@11"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("11")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
