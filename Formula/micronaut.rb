class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.1.1.tar.gz"
  sha256 "b74c604d4cb23953e4c600bed933ad546c50015302bcbddef6638930473758d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46d9741e3c9c955dfb225a726ee4002b7ac234d6b095ac8a1b4f05aeeb44756f"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a40d724c8dd2411faee8cf998d3d48dacb322fddbf9c6eaf33cb2267c69ceaa"
    sha256 cellar: :any_skip_relocation, catalina:      "c6e9a842bbd54d3abbf259f0a23ab334f9bcf3c44870132f7b4a16e5d09a43fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa7a59769a9f2f4bd31bca32a73897a8f14d85fc4b68686431f46ef3c97ae52"
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
