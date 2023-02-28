class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.6.tar.gz"
  sha256 "a0033547ebce466834299174518ca9f372ac5e755f08dbef3c40aec1d58366bd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "087c8a706d75e14c35d08fd4dda605044033371d36221b506a06cd6bfc7bbeef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d550e446280cb9cd99f11ac9d4c71ef3309cecbe8a7df2cbeacd1d85d7d9e853"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04c4577679ebe5df6be0edde3fac5682cd7ac71f577d176a90c384cda6aceaa8"
    sha256 cellar: :any_skip_relocation, ventura:        "3745bbab069556cbcddb075b8e87894129e076721af6a16755364266f9466596"
    sha256 cellar: :any_skip_relocation, monterey:       "a78dc1900c3dc889350c8e57e48a207d5bd4c18ee21c1e3e31326aa6ccc18830"
    sha256 cellar: :any_skip_relocation, big_sur:        "19d1dad6c71b6c58f6ef9fabd4e5979be89ebb96f662164d4892409aab6ae665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6f592a08e05094de17297621912e193dbccae08a9306b996de16e1ae08de4ef"
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
