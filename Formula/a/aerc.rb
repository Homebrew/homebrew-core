class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.22.0.tar.gz"
  sha256 "f1cd5e358fd836051d4d88c189ecaa025a108b729281985525b45b13bc49e70f"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "3f921ff034dee5fc44c1d74e9917e26c12e1059d39dd8f960aa2507236126174"
    sha256 arm64_sequoia: "c5ea3ee16396f88f9ae4b3e8329004fcece61ade3b7f05b2acbfd19fa4cb2eec"
    sha256 arm64_sonoma:  "f7580e08063ddbe38615b13b791a08a88bcc43c40b0ead8a195f2fa853e64828"
    sha256 sonoma:        "0b40acf275466e94b9269185b969d5a4d165c3358f12f2f8fb6b0b2235cabc2e"
    sha256 arm64_linux:   "7561a5e920b8956729f1ae4923351dc44d7837c5029f93e3cd168041ff9b7640"
    sha256 x86_64_linux:  "e01cd254230d1a37e95c8ed6bf12500d69901f787d248a47e1e197b51a10bfb8"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build
  depends_on "notmuch"

  deny_network_access! [:postinstall, :test]

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV["BUILD_OPTS"] = "-buildmode=pie -trimpath"
    end

    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/aerc -v")
    assert_match(/aerc #{version} \+notmuch\.*/, output)
  end
end
