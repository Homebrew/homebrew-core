class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.6.2.tar.gz"
  sha256 "0790494535d599958178fb87e886c6fbc4e91106f9a6a7b9713f717dde0e0c7a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25bdd45889e83c2501ff742acc274b25f80aefa1d5b573bc52999cd0afdfd2c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abe40b162c891a1df91c3705fc4b37912915507f21472a211c15a4986646ca2f"
    sha256 cellar: :any_skip_relocation, monterey:       "9b62d48d781a79d749a1215a7b110424c76370088f1e6c859c96d88e97f5bf91"
    sha256 cellar: :any_skip_relocation, big_sur:        "27d106ed90638865b62e5df412162ed51c593a0a69e4b8b91b92237906d3cd10"
    sha256 cellar: :any_skip_relocation, catalina:       "d08fa5cffa7349ecd27596412aef97d20098394a7849598d19620ceda8645d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d61940288108ba6239ef320b853ed0f2fe12df6adc62fa7651a30cc51ce2a7a2"
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
