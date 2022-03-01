class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.3.4.tar.gz"
  sha256 "3984ab5cb676ca853b68aa8a6eaf3004038061187609ee7b122f7eb812ad8b9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "479b7035d9fcdc1f3f00c68b9f005986262f994c307188b9f5aa00f12dcd3a31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbeb6a651e1137f9b7838fb3933f34239ca4c17d3f7651a6eff1716ac361042d"
    sha256 cellar: :any_skip_relocation, monterey:       "e2dbd1d47a31a2d1855a14bb6e185eea3dedb29e85b026ba4ebd2305bef8a985"
    sha256 cellar: :any_skip_relocation, big_sur:        "728391f2374b2929935190099e09c01ecff431844c6481b97afe56f34321b439"
    sha256 cellar: :any_skip_relocation, catalina:       "f19cccd8391655c46cb6d727aa5849bd2b5eefd4824b30ccf25e415537e9615a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982ca06b084acb0b39c50a4b973e6f901217fa10e7687c1628f731b20b228d88"
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
