class Crip < Formula
  desc "Tool to extract server certificates"
  homepage "https://github.com/Hakky54/certificate-ripper"
  url "https://github.com/Hakky54/certificate-ripper/archive/refs/tags/2.7.1.tar.gz"
  sha256 "d73bc25c3ab37467764310e8573895953b4ff80cf045d96c90aa3c24a67a4f05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea0964d4b1ddc23e45553ef3c79cf64abe268d68a843889e6aa14d769d000667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea0964d4b1ddc23e45553ef3c79cf64abe268d68a843889e6aa14d769d000667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea0964d4b1ddc23e45553ef3c79cf64abe268d68a843889e6aa14d769d000667"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea0964d4b1ddc23e45553ef3c79cf64abe268d68a843889e6aa14d769d000667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f168b5098ac9ee43fba009ed7473dc040b97b20ff8339c704dbace009f10f2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f168b5098ac9ee43fba009ed7473dc040b97b20ff8339c704dbace009f10f2ca"
  end

  depends_on "graalvm" => :build
  depends_on "maven" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = if OS.mac?
      Formula["graalvm"].opt_libexec/"graalvm.jdk/Contents/Home"
    else
      Formula["graalvm"].opt_libexec
    end

    required_keys = %w[
      HOMEBREW_RUBY_PATH
      HOMEBREW_CC
      HOMEBREW_CELLAR
      HOMEBREW_OPT
      HOMEBREW_LIBRARY_PATHS
      HOMEBREW_RPATH_PATHS
    ]
    native_image_env = required_keys.map { |key| "-E#{key}" }
    ENV.prepend "NATIVE_IMAGE_OPTIONS", native_image_env.join(" ")

    system "mvn", "clean", "package", "-Pnative-image", "-DskipTests=true"
    bin.install "target/crip"
  end

  test do
    output = shell_output("#{bin}/crip print -u=https://github.com")
    assert_includes output, "Certificate ripper statistics"
    assert_includes output, "Certificate count"
    assert_includes output, "Certificates for url = https://github.com"

    output = shell_output("#{bin}/crip export p12 -u=https://github.com")
    assert_includes output, "Certificate ripper statistics"
    assert_includes output, "Certificate count"
    assert_includes output, "It has been exported to"
  end
end
