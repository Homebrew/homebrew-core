class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.6.1.tar.gz"
  sha256 "6dad371946523488f1da120e4e2983d914cdc179a3b3280e4f2b3715ca1df9b1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e78e5b5cd68a2e00a22301cec0e23a3d7162f4a96c68c2d4227487de2e98726"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "675367ee2b452e0295f779d95290b77dcd6bd8647061602898ad41eb2a2d4c96"
    sha256 cellar: :any_skip_relocation, monterey:       "0a75e8598693c0edc528d3f2f406ba94bc7bd527f30d869223694ab82612352f"
    sha256 cellar: :any_skip_relocation, big_sur:        "465f2480704e43a3028168ad43223cda2fc67e564af49044c07f912f96e16725"
    sha256 cellar: :any_skip_relocation, catalina:       "2c4fb75a3f43ac49df11605b0fa4997906391fc75b841175b277100205a388fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e527802628109ac271493d92a6d123d0797825dd6d7037f8c3d547950758ab0"
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
