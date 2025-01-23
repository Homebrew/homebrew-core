class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/owasp-noir/noir"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "59d62446ce42797f3834a13f7453f80902d80c681e5b8f969dee9118a104b990"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "205b6311807258e529d6ae93ae60efefca6557aee64023f9e434fc1e28e6b3b5"
    sha256 arm64_sonoma:  "3eb3a6927600c55dececde41da2276572513e90df8076516fcc97a5e04210148"
    sha256 arm64_ventura: "4dec810a3a46dbe366b6361c35bcef3623fd68fa35f93f5a59234aae14f4ec19"
    sha256 sonoma:        "816262ac5598cb3e427d003d939a0032d9ce02863e0bfa912eca183c63b64cc5"
    sha256 ventura:       "d005f6e9855f1bece79d43368a09c7b79e45ab116f3c6517ef4ea13283f54519"
    sha256 x86_64_linux:  "53773fc10ea1dc1056bfb4761ebc79707836ef9a995de4b240d8094c235f2bfc"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"

    generate_completions_from_executable(bin/"noir", shell_parameter_format: "--generate-completion=",
                                                     shells:                 [:bash, :zsh, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/owasp-noir/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
