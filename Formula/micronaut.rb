class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.7.3.tar.gz"
  sha256 "6741bf0a53aae609790ea820bb29138c7398bdad81c0c805a0572b02a2895b44"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aaa83b9f0dc8c1bc96064020388b90dd96ff38f9111e2b4675d8a3f0586e547"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ec2c72c32927f403c83aab966f9567b5612ed8ef79607c4ef6e75e30023dab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acb00b8e4ab9c1e83d7b34368bc928898a92c96bbc268542efcddbe14d0d52b7"
    sha256 cellar: :any_skip_relocation, monterey:       "19e33a30cd3d595b304cb97e31aad1520225f09054b8fa589bdeaf33d78b52bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cb71c75a9737cb9110faec6403291aa7b6e9b30c6494d2f7f25cb9ed8b62713"
    sha256 cellar: :any_skip_relocation, catalina:       "96cedb051e34931f2b9c66590ec8e76e23b5880c6bfa49e71dc7f04e6cfd5478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ec6adab0a227c3a20a8853da935fceb296045c356c679a7ea946e9ec536531"
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
