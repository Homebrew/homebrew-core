class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "a47061b8156cd7eecd56f1e25a67cfe68a4afb26dc8404f69d4b1d37e7dd8c6c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f644862ffcd69ad2dcd8042e4486cea6a436233fef75ea24cc636069bb224f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab8b1718a8ab89a5ad1416cef493b340f9bf33937b33acfbffd75410284281b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2914ace0729de7fd9f0fb8dcc9441ca04bd5ab5bb8268207f696b23ccb182755"
    sha256 cellar: :any_skip_relocation, ventura:        "a8b4124b4915c14d9738d96db924dd9302ce02b2aa5cf93e8da3685dd788a3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "f052e1383402b8141a88acf6c909d554b84fb8c2326111e06437211e155ac2f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8717d17412d4cf8f75f8335cf722c517ac916b3b842bcdec33666201683eac95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cddcaa9eb3617bd48dfa780677c68fb9c098e346dd56579f3e61b4cf7955bda"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@17"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
