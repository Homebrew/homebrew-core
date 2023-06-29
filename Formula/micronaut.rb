class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.9.4.tar.gz"
  sha256 "7b4bf3abffaed56e9300d15a03e07d022a7905bfd3ab581dd3d2b8eba4bd6381"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbcd0f5f77f8a05c5e14a5cef8a935b8ca75dfb558e5f3945650df65a5b76232"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a43a0dd21556a53841d7c7afb924095eef9e3435fec5a7a856aa0ed0008467ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dde18a6671df0d23d751e93e53da7a9f5ee042d401f412efd5908611b8c0f71e"
    sha256 cellar: :any_skip_relocation, ventura:        "3347c3f07858076b34bccf1b6ae572a4cfe8d4620b2ac1ab9bfb4be914f27222"
    sha256 cellar: :any_skip_relocation, monterey:       "ffa2fbf07521016b12191aff8f6edbf32553ff6f9a7ade1e4370692f042b4e54"
    sha256 cellar: :any_skip_relocation, big_sur:        "300f3ebba5c6f88ede8143c2aa10bc0cacc77037ecb534b60ab0cd2209523604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9acb29e54569cdafc621b884f538bfa0ed712d68eb5f7f36053c0270e563643"
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
