class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.8.1.tar.gz"
  sha256 "9bc249fe239dc6231f450ca8a08928f0b3eb66d71dc002cfaf31d2db0f4cf73e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e3b8e51f21b5b26b0dc63525c2cf7d78e60d24b0eed180a2e368f63d4d9715e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59e829f8a58c14106ddfc4827e28e6985f0a8ff2706db7cf2a0d383ae5b72453"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb851970f452a7c1f0a2daccb71775a3d5e552e29551b783476eb49699412c96"
    sha256 cellar: :any_skip_relocation, ventura:        "4da4872710ca3eaa67dd8f14a8d72278e5714195c0ccb0d585309935d704e3f1"
    sha256 cellar: :any_skip_relocation, monterey:       "510c1b08e8244ba3dad463f4cbf356e7bf13421d3455b3034b37fbce987150ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "469728afb35343c3daa47a7a6865e323164367f44d4d83961b963c8051fb4ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00edbcf80005dff1b6a2754bee35ab61a2b7a58b17e92aafdbcfea19b7909cc0"
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
