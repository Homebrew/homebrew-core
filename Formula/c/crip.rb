class Crip < Formula
  desc "Tool to extract server certificates"
  homepage "https://github.com/Hakky54/certificate-ripper"
  url "https://github.com/Hakky54/certificate-ripper/archive/refs/tags/2.7.1.tar.gz"
  sha256 "d73bc25c3ab37467764310e8573895953b4ff80cf045d96c90aa3c24a67a4f05"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca2b51dd1f72872c202f2a8be9358f16cd5a204de372a37ca6b32678b6fdba55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80801324dc53446dc5bd878b47b9fd7fec99e63d007d73019ab55626e6287d2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a35197075d7a7ac533eb5e47ace9615e19851031668871d606e01b7332e1a178"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9597c2992defaa24e79d08a1773829ef326e8ee0aac917bd36809a1713510577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17d165d884e5f84a2e93511eae28052f881a71bd7dcbd87f6b52e4114038f048"
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
