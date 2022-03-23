class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.4.0.tar.gz"
  sha256 "1feed38c38e3f0cb66cb392d472c269260fdb8de8418117749c5354b9ba81d56"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f48dd0d2b7eb9a4be494e18e068f5702b9d5358dcb728c14e62876ba037a1bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f91a2d436500b28e26dcbf5dcad539b43fb8795a885a63028a5a5bdee43adba"
    sha256 cellar: :any_skip_relocation, monterey:       "26291182be3b933974365289ef565c14dbaa182f9e2563b78fc8fe4914402761"
    sha256 cellar: :any_skip_relocation, big_sur:        "99f13ca7781191b5d41c14ac8ddf96ab9536146397d2e7796ba3d9241f9c8787"
    sha256 cellar: :any_skip_relocation, catalina:       "ed35a73b6f75825bd1619566bffd083b106bc3aea63dafff90de1143e03e7603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8b5b843da5101a81dff003bc99462b2891421cde654bd5914d6d8a5c61fc90d"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
