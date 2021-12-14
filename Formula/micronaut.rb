class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.2.2.tar.gz"
  sha256 "fc24e9e9740a451cc380db71394db643fdd5e194a2e8efb5a1794aa092edbf3e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "edc7e9e60289dbeff82110cb2579444935e0ff46f07409324704e62037bb7608"
    sha256 cellar: :any_skip_relocation, big_sur:       "8171ef4d48a63d00a81bc0868c37f02bc9d03a9168e3a77805230f2026e652ce"
    sha256 cellar: :any_skip_relocation, catalina:      "d4d3220f26329da02ec3aacda673f2c9edb4108652694a27ee5b327586bc76fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a293beb54377a08f1e0a8a1ea544e6e1f6ac5cf4571c570ebf2e71b7b487e5"
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
