class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "f1a22313e92178f174ab4d6c2217633daa60cb1365de7c94a5aa59d7e61e4f10"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7a2f16930a4c7ee627b30561abf4c63e0ab1c55736994522c3a5f72f1e3a253"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cf40744f62ee76ddcdf6a75d1afc911696272fb1a67e7fe118e86b3d6982642"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4892155caec7cbe1daf77673bd6f8a358fece16ed11e2e591c32416a02062f4"
    sha256 cellar: :any_skip_relocation, ventura:        "b6390bcac5f67c01393b8e8a3ca6c4cead42007d7ae6729192b7c3f9bdb080f1"
    sha256 cellar: :any_skip_relocation, monterey:       "80008fd91815ecdb41119f5230ad1e4d3d6433b6f679fa7c14ccf24248cc9842"
    sha256 cellar: :any_skip_relocation, big_sur:        "0849dcf2ef536c1eac68b0811ab16645094893f40a0997b2c55a6906edf25e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2445377b43756999f100a68f23b4e00e11bd41a04c8100ee7cb8d2771f48be4"
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
